/*-------------------------------------------------------------------------
 *
 * dependencies.c
 *	  POSTGRES functional dependencies
 *
 * Portions Copyright (c) 1996-2017, PostgreSQL Global Development Group
 * Portions Copyright (c) 1994, Regents of the University of California
 *
 * IDENTIFICATION
 *	  src/backend/statistics/dependencies.c
 *
 *-------------------------------------------------------------------------
 */
#include "postgres.h"

#include "access/htup_details.h"
#include "access/sysattr.h"
#include "catalog/pg_operator.h"
#include "catalog/pg_statistic_ext.h"
#include "lib/stringinfo.h"
#include "optimizer/clauses.h"
#include "optimizer/cost.h"
#include "optimizer/var.h"
#include "nodes/nodes.h"
#include "nodes/relation.h"
#include "statistics/extended_stats_internal.h"
#include "statistics/statistics.h"
#include "utils/bytea.h"
#include "utils/fmgroids.h"
#include "utils/fmgrprotos.h"
#include "utils/lsyscache.h"
#include "utils/syscache.h"
#include "utils/typcache.h"

/*
 * Internal state for DependencyGenerator of dependencies. Dependencies are similar to
 * k-permutations of n elements, except that the order does not matter for the
 * first (k-1) elements. That is, (a,b=>c) and (b,a=>c) are equivalent.
 */
typedef struct DependencyGeneratorData
{
	int			k;				/* size of the dependency */
	int			n;				/* number of possible attributes */
	int			current;		/* next dependency to return (index) */
	AttrNumber	ndependencies;	/* number of dependencies generated */
	AttrNumber *dependencies;	/* array of pre-generated dependencies	*/
} DependencyGeneratorData;

typedef DependencyGeneratorData *DependencyGenerator;

static void generate_dependencies_recurse(DependencyGenerator state,
							  int index, AttrNumber start, AttrNumber *current);
static void generate_dependencies(DependencyGenerator state);
static DependencyGenerator DependencyGenerator_init(int n, int k);
static void DependencyGenerator_free(DependencyGenerator state);
static AttrNumber *DependencyGenerator_next(DependencyGenerator state);
static double dependency_degree(int numrows, HeapTuple *rows, int k,
				  AttrNumber *dependency, VacAttrStats **stats, Bitmapset *attrs);
static bool dependency_is_fully_matched(MVDependency *dependency,
							Bitmapset *attnums);
static bool dependency_implies_attribute(MVDependency *dependency,
							 AttrNumber attnum);
static bool dependency_is_compatible_clause(Node *clause, Index relid,
								AttrNumber *attnum);
static MVDependency *find_strongest_dependency(StatisticExtInfo *stats,
						  MVDependencies *dependencies,
						  Bitmapset *attnums);

static void
generate_dependencies_recurse(DependencyGenerator state, int index,
							  AttrNumber start, AttrNumber *current)
{
	/*
	 * The generator handles the first (k-1) elements differently from the
	 * last element.
	 */
	if (index < (state->k - 1))
	{
		AttrNumber	i;

		/*
		 * The first (k-1) values have to be in ascending order, which we
		 * generate recursively.
		 */

		for (i = start; i < state->n; i++)
		{
			current[index] = i;
			generate_dependencies_recurse(state, (index + 1), (i + 1), current);
		}
	}
	else
	{
		int			i;

		/*
		 * the last element is the implied value, which does not respect the
		 * ascending order. We just need to check that the value is not in the
		 * first (k-1) elements.
		 */

		for (i = 0; i < state->n; i++)
		{
			int			j;
			bool		match = false;

			current[index] = i;

			for (j = 0; j < index; j++)
			{
				if (current[j] == i)
				{
					match = true;
					break;
				}
			}

			/*
			 * If the value is not found in the first part of the dependency,
			 * we're done.
			 */
			if (!match)
			{
				state->dependencies = (AttrNumber *) repalloc(state->dependencies,
															  state->k * (state->ndependencies + 1) * sizeof(AttrNumber));
				memcpy(&state->dependencies[(state->k * state->ndependencies)],
					   current, state->k * sizeof(AttrNumber));
				state->ndependencies++;
			}
		}
	}
}

/* generate all dependencies (k-permutations of n elements) */
static void
generate_dependencies(DependencyGenerator state)
{
	AttrNumber *current = (AttrNumber *) palloc0(sizeof(AttrNumber) * state->k);

	generate_dependencies_recurse(state, 0, 0, current);

	pfree(current);
}

/*
 * initialize the DependencyGenerator of variations, and prebuild the variations
 *
 * This pre-builds all the variations. We could also generate them in
 * DependencyGenerator_next(), but this seems simpler.
 */
static DependencyGenerator
DependencyGenerator_init(int n, int k)
{
	DependencyGenerator state;

	Assert((n >= k) && (k > 0));

	/* allocate the DependencyGenerator state */
	state = (DependencyGenerator) palloc0(sizeof(DependencyGeneratorData));
	state->dependencies = (AttrNumber *) palloc(k * sizeof(AttrNumber));

	state->ndependencies = 0;
	state->current = 0;
	state->k = k;
	state->n = n;

	/* now actually pre-generate all the variations */
	generate_dependencies(state);

	return state;
}

/* free the DependencyGenerator state */
static void
DependencyGenerator_free(DependencyGenerator state)
{
	pfree(state->dependencies);
	pfree(state);

}

/* generate next combination */
static AttrNumber *
DependencyGenerator_next(DependencyGenerator state)
{
	if (state->current == state->ndependencies)
		return NULL;

	return &state->dependencies[state->k * state->current++];
}


/*
 * validates functional dependency on the data
 *
 * An actual work horse of detecting functional dependencies. Given a variation
 * of k attributes, it checks that the first (k-1) are sufficient to determine
 * the last one.
 */
static double
dependency_degree(int numrows, HeapTuple *rows, int k, AttrNumber *dependency,
				  VacAttrStats **stats, Bitmapset *attrs)
{
	int			i,
				j;
	int			nvalues = numrows * k;
	MultiSortSupport mss;
	SortItem   *items;
	Datum	   *values;
	bool	   *isnull;
	int		   *attnums;

	/* counters valid within a group */
	int			group_size = 0;
	int			n_violations = 0;

	/* total number of rows supporting (consistent with) the dependency */
	int			n_supporting_rows = 0;

	/* Make sure we have at least two input attributes. */
	Assert(k >= 2);

	/* sort info for all attributes columns */
	mss = multi_sort_init(k);

	/* data for the sort */
	items = (SortItem *) palloc(numrows * sizeof(SortItem));
	values = (Datum *) palloc(sizeof(Datum) * nvalues);
	isnull = (bool *) palloc(sizeof(bool) * nvalues);

	/* fix the pointers to values/isnull */
	for (i = 0; i < numrows; i++)
	{
		items[i].values = &values[i * k];
		items[i].isnull = &isnull[i * k];
	}

	/*
	 * Transform the bms into an array, to make accessing i-th member easier.
	 */
	attnums = (int *) palloc(sizeof(int) * bms_num_members(attrs));
	i = 0;
	j = -1;
	while ((j = bms_next_member(attrs, j)) >= 0)
		attnums[i++] = j;

	/*
	 * Verify the dependency (a,b,...)->z, using a rather simple algorithm:
	 *
	 * (a) sort the data lexicographically
	 *
	 * (b) split the data into groups by first (k-1) columns
	 *
	 * (c) for each group count different values in the last column
	 */

	/* prepare the sort function for the first dimension, and SortItem array */
	for (i = 0; i < k; i++)
	{
		VacAttrStats *colstat = stats[dependency[i]];
		TypeCacheEntry *type;

		type = lookup_type_cache(colstat->attrtypid, TYPECACHE_LT_OPR);
		if (type->lt_opr == InvalidOid) /* shouldn't happen */
			elog(ERROR, "cache lookup failed for ordering operator for type %u",
				 colstat->attrtypid);

		/* prepare the sort function for this dimension */
		multi_sort_add_dimension(mss, i, type->lt_opr);

		/* accumulate all the data for both columns into an array and sort it */
		for (j = 0; j < numrows; j++)
		{
			items[j].values[i] =
				heap_getattr(rows[j], attnums[dependency[i]],
							 stats[i]->tupDesc, &items[j].isnull[i]);
		}
	}

	/* sort the items so that we can detect the groups */
	qsort_arg((void *) items, numrows, sizeof(SortItem),
			  multi_sort_compare, mss);

	/*
	 * Walk through the sorted array, split it into rows according to the
	 * first (k-1) columns. If there's a single value in the last column, we
	 * count the group as 'supporting' the functional dependency. Otherwise we
	 * count it as contradicting.
	 */

	/* start with the first row forming a group */
	group_size = 1;

	/* loop 1 beyond the end of the array so that we count the final group */
	for (i = 1; i <= numrows; i++)
	{
		/*
		 * Check if the group ended, which may be either because we processed
		 * all the items (i==numrows), or because the i-th item is not equal
		 * to the preceding one.
		 */
		if (i == numrows ||
			multi_sort_compare_dims(0, k - 2, &items[i - 1], &items[i], mss) != 0)
		{
			/*
			 * If no violations were found in the group then track the rows of
			 * the group as supporting the functional dependency.
			 */
			if (n_violations == 0)
				n_supporting_rows += group_size;

			/* Reset counters for the new group */
			n_violations = 0;
			group_size = 1;
			continue;
		}
		/* first columns match, but the last one does not (so contradicting) */
		else if (multi_sort_compare_dim(k - 1, &items[i - 1], &items[i], mss) != 0)
			n_violations++;

		group_size++;
	}

	pfree(items);
	pfree(values);
	pfree(isnull);
	pfree(mss);

	/* Compute the 'degree of validity' as (supporting/total). */
	return (n_supporting_rows * 1.0 / numrows);
}

/*
 * detects functional dependencies between groups of columns
 *
 * Generates all possible subsets of columns (variations) and computes
 * the degree of validity for each one. For example when creating statistics
 * on three columns (a,b,c) there are 9 possible dependencies
 *
 *	   two columns			  three columns
 *	   -----------			  -------------
 *	   (a) -> b				  (a,b) -> c
 *	   (a) -> c				  (a,c) -> b
 *	   (b) -> a				  (b,c) -> a
 *	   (b) -> c
 *	   (c) -> a
 *	   (c) -> b
 */
MVDependencies *
statext_dependencies_build(int numrows, HeapTuple *rows, Bitmapset *attrs,
						   VacAttrStats **stats)
{
	int			i,
				j,
				k;
	int			numattrs;
	int		   *attnums;

	/* result */
	MVDependencies *dependencies = NULL;

	numattrs = bms_num_members(attrs);

	/*
	 * Transform the bms into an array, to make accessing i-th member easier.
	 */
	attnums = palloc(sizeof(int) * bms_num_members(attrs));
	i = 0;
	j = -1;
	while ((j = bms_next_member(attrs, j)) >= 0)
		attnums[i++] = j;

	Assert(numattrs >= 2);

	/*
	 * We'll try build functional dependencies starting from the smallest ones
	 * covering just 2 columns, to the largest ones, covering all columns
	 * included in the statistics object.  We start from the smallest ones
	 * because we want to be able to skip already implied ones.
	 */
	for (k = 2; k <= numattrs; k++)
	{
		AttrNumber *dependency; /* array with k elements */

		/* prepare a DependencyGenerator of variation */
		DependencyGenerator DependencyGenerator = DependencyGenerator_init(numattrs, k);

		/* generate all possible variations of k values (out of n) */
		while ((dependency = DependencyGenerator_next(DependencyGenerator)))
		{
			double		degree;
			MVDependency *d;

			/* compute how valid the dependency seems */
			degree = dependency_degree(numrows, rows, k, dependency, stats, attrs);

			/*
			 * if the dependency seems entirely invalid, don't store it it
			 */
			if (degree == 0.0)
				continue;

			d = (MVDependency *) palloc0(offsetof(MVDependency, attributes)
										 + k * sizeof(AttrNumber));

			/* copy the dependency (and keep the indexes into stxkeys) */
			d->degree = degree;
			d->nattributes = k;
			for (i = 0; i < k; i++)
				d->attributes[i] = attnums[dependency[i]];

			/* initialize the list of dependencies */
			if (dependencies == NULL)
			{
				dependencies
					= (MVDependencies *) palloc0(sizeof(MVDependencies));

				dependencies->magic = STATS_DEPS_MAGIC;
				dependencies->type = STATS_DEPS_TYPE_BASIC;
				dependencies->ndeps = 0;
			}

			dependencies->ndeps++;
			dependencies = (MVDependencies *) repalloc(dependencies,
													   offsetof(MVDependencies, deps)
													   + dependencies->ndeps * sizeof(MVDependency));

			dependencies->deps[dependencies->ndeps - 1] = d;
		}

		/*
		 * we're done with variations of k elements, so free the
		 * DependencyGenerator
		 */
		DependencyGenerator_free(DependencyGenerator);
	}

	return dependencies;
}


/*
 * Serialize list of dependencies into a bytea value.
 */
bytea *
statext_dependencies_serialize(MVDependencies *dependencies)
{
	int			i;
	bytea	   *output;
	char	   *tmp;
	Size		len;

	/* we need to store ndeps, with a number of attributes for each one */
	len = VARHDRSZ + SizeOfDependencies
		+ dependencies->ndeps * SizeOfDependency;

	/* and also include space for the actual attribute numbers and degrees */
	for (i = 0; i < dependencies->ndeps; i++)
		len += (sizeof(AttrNumber) * dependencies->deps[i]->nattributes);

	output = (bytea *) palloc0(len);
	SET_VARSIZE(output, len);

	tmp = VARDATA(output);

	/* Store the base struct values (magic, type, ndeps) */
	memcpy(tmp, &dependencies->magic, sizeof(uint32));
	tmp += sizeof(uint32);
	memcpy(tmp, &dependencies->type, sizeof(uint32));
	tmp += sizeof(uint32);
	memcpy(tmp, &dependencies->ndeps, sizeof(uint32));
	tmp += sizeof(uint32);

	/* store number of attributes and attribute numbers for each dependency */
	for (i = 0; i < dependencies->ndeps; i++)
	{
		MVDependency *d = dependencies->deps[i];

		memcpy(tmp, d, SizeOfDependency);
		tmp += SizeOfDependency;

		memcpy(tmp, d->attributes, sizeof(AttrNumber) * d->nattributes);
		tmp += sizeof(AttrNumber) * d->nattributes;

		Assert(tmp <= ((char *) output + len));
	}

	return output;
}

/*
 * Reads serialized dependencies into MVDependencies structure.
 */
MVDependencies *
statext_dependencies_deserialize(bytea *data)
{
	int			i;
	Size		min_expected_size;
	MVDependencies *dependencies;
	char	   *tmp;

	if (data == NULL)
		return NULL;

	if (VARSIZE_ANY_EXHDR(data) < SizeOfDependencies)
		elog(ERROR, "invalid MVDependencies size %zd (expected at least %zd)",
			 VARSIZE_ANY_EXHDR(data), SizeOfDependencies);

	/* read the MVDependencies header */
	dependencies = (MVDependencies *) palloc0(sizeof(MVDependencies));

	/* initialize pointer to the data part (skip the varlena header) */
	tmp = VARDATA_ANY(data);

	/* read the header fields and perform basic sanity checks */
	memcpy(&dependencies->magic, tmp, sizeof(uint32));
	tmp += sizeof(uint32);
	memcpy(&dependencies->type, tmp, sizeof(uint32));
	tmp += sizeof(uint32);
	memcpy(&dependencies->ndeps, tmp, sizeof(uint32));
	tmp += sizeof(uint32);

	if (dependencies->magic != STATS_DEPS_MAGIC)
		elog(ERROR, "invalid dependency magic %d (expected %d)",
			 dependencies->magic, STATS_DEPS_MAGIC);

	if (dependencies->type != STATS_DEPS_TYPE_BASIC)
		elog(ERROR, "invalid dependency type %d (expected %d)",
			 dependencies->type, STATS_DEPS_TYPE_BASIC);

	if (dependencies->ndeps == 0)
		ereport(ERROR,
				(errcode(ERRCODE_DATA_CORRUPTED),
				 errmsg("invalid zero-length item array in MVDependencies")));

	/* what minimum bytea size do we expect for those parameters */
	min_expected_size = SizeOfDependencies +
		dependencies->ndeps * (SizeOfDependency +
							   sizeof(AttrNumber) * 2);

	if (VARSIZE_ANY_EXHDR(data) < min_expected_size)
		elog(ERROR, "invalid dependencies size %zd (expected at least %zd)",
			 VARSIZE_ANY_EXHDR(data), min_expected_size);

	/* allocate space for the MCV items */
	dependencies = repalloc(dependencies, offsetof(MVDependencies, deps)
							+ (dependencies->ndeps * sizeof(MVDependency *)));

	for (i = 0; i < dependencies->ndeps; i++)
	{
		double		degree;
		AttrNumber	k;
		MVDependency *d;

		/* degree of validity */
		memcpy(&degree, tmp, sizeof(double));
		tmp += sizeof(double);

		/* number of attributes */
		memcpy(&k, tmp, sizeof(AttrNumber));
		tmp += sizeof(AttrNumber);

		/* is the number of attributes valid? */
		Assert((k >= 2) && (k <= STATS_MAX_DIMENSIONS));

		/* now that we know the number of attributes, allocate the dependency */
		d = (MVDependency *) palloc0(offsetof(MVDependency, attributes)
									 + (k * sizeof(AttrNumber)));

		d->degree = degree;
		d->nattributes = k;

		/* copy attribute numbers */
		memcpy(d->attributes, tmp, sizeof(AttrNumber) * d->nattributes);
		tmp += sizeof(AttrNumber) * d->nattributes;

		dependencies->deps[i] = d;

		/* still within the bytea */
		Assert(tmp <= ((char *) data + VARSIZE_ANY(data)));
	}

	/* we should have consumed the whole bytea exactly */
	Assert(tmp == ((char *) data + VARSIZE_ANY(data)));

	return dependencies;
}

/*
 * dependency_is_fully_matched
 *		checks that a functional dependency is fully matched given clauses on
 *		attributes (assuming the clauses are suitable equality clauses)
 */
static bool
dependency_is_fully_matched(MVDependency *dependency, Bitmapset *attnums)
{
	int			j;

	/*
	 * Check that the dependency actually is fully covered by clauses. We have
	 * to translate all attribute numbers, as those are referenced
	 */
	for (j = 0; j < dependency->nattributes; j++)
	{
		int			attnum = dependency->attributes[j];

		if (!bms_is_member(attnum, attnums))
			return false;
	}

	return true;
}

/*
 * dependency_implies_attribute
 *		check that the attnum matches is implied by the functional dependency
 */
static bool
dependency_implies_attribute(MVDependency *dependency, AttrNumber attnum)
{
	if (attnum == dependency->attributes[dependency->nattributes - 1])
		return true;

	return false;
}

/*
 * statext_dependencies_load
 *		Load the functional dependencies for the indicated pg_statistic_ext tuple
 */
MVDependencies *
statext_dependencies_load(Oid mvoid)
{
	bool		isnull;
	Datum		deps;
	HeapTuple	htup = SearchSysCache1(STATEXTOID, ObjectIdGetDatum(mvoid));

	if (!HeapTupleIsValid(htup))
		elog(ERROR, "cache lookup failed for statistics object %u", mvoid);

	deps = SysCacheGetAttr(STATEXTOID, htup,
						   Anum_pg_statistic_ext_stxdependencies, &isnull);
	Assert(!isnull);

	ReleaseSysCache(htup);

	return statext_dependencies_deserialize(DatumGetByteaP(deps));
}

/*
 * pg_dependencies_in		- input routine for type pg_dependencies.
 *
 * pg_dependencies is real enough to be a table column, but it has no operations
 * of its own, and disallows input too
 */
Datum
pg_dependencies_in(PG_FUNCTION_ARGS)
{
	/*
	 * pg_node_list stores the data in binary form and parsing text input is
	 * not needed, so disallow this.
	 */
	ereport(ERROR,
			(errcode(ERRCODE_FEATURE_NOT_SUPPORTED),
			 errmsg("cannot accept a value of type %s", "pg_dependencies")));

	PG_RETURN_VOID();			/* keep compiler quiet */
}

/*
 * pg_dependencies		- output routine for type pg_dependencies.
 */
Datum
pg_dependencies_out(PG_FUNCTION_ARGS)
{
	bytea	   *data = PG_GETARG_BYTEA_PP(0);
	MVDependencies *dependencies = statext_dependencies_deserialize(data);
	int			i,
				j;
	StringInfoData str;

	initStringInfo(&str);
	appendStringInfoChar(&str, '{');

	for (i = 0; i < dependencies->ndeps; i++)
	{
		MVDependency *dependency = dependencies->deps[i];

		if (i > 0)
			appendStringInfoString(&str, ", ");

		appendStringInfoChar(&str, '"');
		for (j = 0; j < dependency->nattributes; j++)
		{
			if (j == dependency->nattributes - 1)
				appendStringInfoString(&str, " => ");
			else if (j > 0)
				appendStringInfoString(&str, ", ");

			appendStringInfo(&str, "%d", dependency->attributes[j]);
		}
		appendStringInfo(&str, "\": %f", dependency->degree);
	}

	appendStringInfoChar(&str, '}');

	PG_RETURN_CSTRING(str.data);
}

/*
 * pg_dependencies_recv		- binary input routine for type pg_dependencies.
 */
Datum
pg_dependencies_recv(PG_FUNCTION_ARGS)
{
	ereport(ERROR,
			(errcode(ERRCODE_FEATURE_NOT_SUPPORTED),
			 errmsg("cannot accept a value of type %s", "pg_dependencies")));

	PG_RETURN_VOID();			/* keep compiler quiet */
}

/*
 * pg_dependencies_send		- binary output routine for type pg_dependencies.
 *
 * Functional dependencies are serialized in a bytea value (although the type
 * is named differently), so let's just send that.
 */
Datum
pg_dependencies_send(PG_FUNCTION_ARGS)
{
	return byteasend(fcinfo);
}

/*
 * dependency_is_compatible_clause
 *		Determines if the clause is compatible with functional dependencies
 *
 * Only clauses that have the form of equality to a pseudoconstant, or can be
 * interpreted that way, are currently accepted.  Furthermore the variable
 * part of the clause must be a simple Var belonging to the specified
 * relation, whose attribute number we return in *attnum on success.
 */
static bool
dependency_is_compatible_clause(Node *clause, Index relid, AttrNumber *attnum)
{
	RestrictInfo *rinfo = (RestrictInfo *) clause;
	Var		   *var;

	if (!IsA(rinfo, RestrictInfo))
		return false;

	/* Pseudoconstants are not interesting (they couldn't contain a Var) */
	if (rinfo->pseudoconstant)
		return false;

	/* Clauses referencing multiple, or no, varnos are incompatible */
	if (bms_membership(rinfo->clause_relids) != BMS_SINGLETON)
		return false;

	if (is_opclause(rinfo->clause))
	{
		/* If it's an opclause, check for Var = Const or Const = Var. */
		OpExpr	   *expr = (OpExpr *) rinfo->clause;

		/* Only expressions with two arguments are candidates. */
		if (list_length(expr->args) != 2)
			return false;

		/* Make sure non-selected argument is a pseudoconstant. */
		if (is_pseudo_constant_clause(lsecond(expr->args)))
			var = linitial(expr->args);
		else if (is_pseudo_constant_clause(linitial(expr->args)))
			var = lsecond(expr->args);
		else
			return false;

		/*
		 * If it's not an "=" operator, just ignore the clause, as it's not
		 * compatible with functional dependencies.
		 *
		 * This uses the function for estimating selectivity, not the operator
		 * directly (a bit awkward, but well ...).
		 *
		 * XXX this is pretty dubious; probably it'd be better to check btree
		 * or hash opclass membership, so as not to be fooled by custom
		 * selectivity functions, and to be more consistent with decisions
		 * elsewhere in the planner.
		 */
		if (get_oprrest(expr->opno) != F_EQSEL)
			return false;

		/* OK to proceed with checking "var" */
	}
	else if (not_clause((Node *) rinfo->clause))
	{
		/*
		 * "NOT x" can be interpreted as "x = false", so get the argument and
		 * proceed with seeing if it's a suitable Var.
		 */
		var = (Var *) get_notclausearg(rinfo->clause);
	}
	else
	{
		/*
		 * A boolean expression "x" can be interpreted as "x = true", so
		 * proceed with seeing if it's a suitable Var.
		 */
		var = (Var *) rinfo->clause;
	}

	/*
	 * We may ignore any RelabelType node above the operand.  (There won't be
	 * more than one, since eval_const_expressions has been applied already.)
	 */
	if (IsA(var, RelabelType))
		var = (Var *) ((RelabelType *) var)->arg;

	/* We only support plain Vars for now */
	if (!IsA(var, Var))
		return false;

	/* Ensure Var is from the correct relation */
	if (var->varno != relid)
		return false;

	/* We also better ensure the Var is from the current level */
	if (var->varlevelsup != 0)
		return false;

	/* Also ignore system attributes (we don't allow stats on those) */
	if (!AttrNumberIsForUserDefinedAttr(var->varattno))
		return false;

	*attnum = var->varattno;
	return true;
}

/*
 * find_strongest_dependency
 *		find the strongest dependency on the attributes
 *
 * When applying functional dependencies, we start with the strongest
 * dependencies. That is, we select the dependency that:
 *
 * (a) has all attributes covered by equality clauses
 *
 * (b) has the most attributes
 *
 * (c) has the highest degree of validity
 *
 * This guarantees that we eliminate the most redundant conditions first
 * (see the comment in dependencies_clauselist_selectivity).
 */
static MVDependency *
find_strongest_dependency(StatisticExtInfo *stats, MVDependencies *dependencies,
						  Bitmapset *attnums)
{
	int			i;
	MVDependency *strongest = NULL;

	/* number of attnums in clauses */
	int			nattnums = bms_num_members(attnums);

	/*
	 * Iterate over the MVDependency items and find the strongest one from the
	 * fully-matched dependencies. We do the cheap checks first, before
	 * matching it against the attnums.
	 */
	for (i = 0; i < dependencies->ndeps; i++)
	{
		MVDependency *dependency = dependencies->deps[i];

		/*
		 * Skip dependencies referencing more attributes than available
		 * clauses, as those can't be fully matched.
		 */
		if (dependency->nattributes > nattnums)
			continue;

		if (strongest)
		{
			/* skip dependencies on fewer attributes than the strongest. */
			if (dependency->nattributes < strongest->nattributes)
				continue;

			/* also skip weaker dependencies when attribute count matches */
			if (strongest->nattributes == dependency->nattributes &&
				strongest->degree > dependency->degree)
				continue;
		}

		/*
		 * this dependency is stronger, but we must still check that it's
		 * fully matched to these attnums. We perform this check last as it's
		 * slightly more expensive than the previous checks.
		 */
		if (dependency_is_fully_matched(dependency, attnums))
			strongest = dependency; /* save new best match */
	}

	return strongest;
}

/*
 * dependencies_clauselist_selectivity
 *		Return the estimated selectivity of (a subset of) the given clauses
 *		using functional dependency statistics, or 1.0 if no useful functional
 *		dependency statistic exists.
 *
 * 'estimatedclauses' is an output argument that gets a bit set corresponding
 * to the (zero-based) list index of each clause that is included in the
 * estimated selectivity.
 *
 * Given equality clauses on attributes (a,b) we find the strongest dependency
 * between them, i.e. either (a=>b) or (b=>a). Assuming (a=>b) is the selected
 * dependency, we then combine the per-clause selectivities using the formula
 *
 *	   P(a,b) = P(a) * [f + (1-f)*P(b)]
 *
 * where 'f' is the degree of the dependency.
 *
 * With clauses on more than two attributes, the dependencies are applied
 * recursively, starting with the widest/strongest dependencies. For example
 * P(a,b,c) is first split like this:
 *
 *	   P(a,b,c) = P(a,b) * [f + (1-f)*P(c)]
 *
 * assuming (a,b=>c) is the strongest dependency.
 */
Selectivity
dependencies_clauselist_selectivity(PlannerInfo *root,
									List *clauses,
									int varRelid,
									JoinType jointype,
									SpecialJoinInfo *sjinfo,
									RelOptInfo *rel,
									Bitmapset **estimatedclauses)
{
	Selectivity s1 = 1.0;
	ListCell   *l;
	Bitmapset  *clauses_attnums = NULL;
	StatisticExtInfo *stat;
	MVDependencies *dependencies;
	AttrNumber *list_attnums;
	int			listidx;

	/* initialize output argument */
	*estimatedclauses = NULL;

	/* check if there's any stats that might be useful for us. */
	if (!has_stats_of_kind(rel->statlist, STATS_EXT_DEPENDENCIES))
		return 1.0;

	list_attnums = (AttrNumber *) palloc(sizeof(AttrNumber) *
										 list_length(clauses));

	/*
	 * Pre-process the clauses list to extract the attnums seen in each item.
	 * We need to determine if there's any clauses which will be useful for
	 * dependency selectivity estimations. Along the way we'll record all of
	 * the attnums for each clause in a list which we'll reference later so we
	 * don't need to repeat the same work again. We'll also keep track of all
	 * attnums seen.
	 */
	listidx = 0;
	foreach(l, clauses)
	{
		Node	   *clause = (Node *) lfirst(l);
		AttrNumber	attnum;

		if (dependency_is_compatible_clause(clause, rel->relid, &attnum))
		{
			list_attnums[listidx] = attnum;
			clauses_attnums = bms_add_member(clauses_attnums, attnum);
		}
		else
			list_attnums[listidx] = InvalidAttrNumber;

		listidx++;
	}

	/*
	 * If there's not at least two distinct attnums then reject the whole list
	 * of clauses. We must return 1.0 so the calling function's selectivity is
	 * unaffected.
	 */
	if (bms_num_members(clauses_attnums) < 2)
	{
		pfree(list_attnums);
		return 1.0;
	}

	/* find the best suited statistics object for these attnums */
	stat = choose_best_statistics(rel->statlist, clauses_attnums,
								  STATS_EXT_DEPENDENCIES);

	/* if no matching stats could be found then we've nothing to do */
	if (!stat)
	{
		pfree(list_attnums);
		return 1.0;
	}

	/* load the dependency items stored in the statistics object */
	dependencies = statext_dependencies_load(stat->statOid);

	/*
	 * Apply the dependencies recursively, starting with the widest/strongest
	 * ones, and proceeding to the smaller/weaker ones. At the end of each
	 * round we factor in the selectivity of clauses on the implied attribute,
	 * and remove the clauses from the list.
	 */
	while (true)
	{
		Selectivity s2 = 1.0;
		MVDependency *dependency;

		/* the widest/strongest dependency, fully matched by clauses */
		dependency = find_strongest_dependency(stat, dependencies,
											   clauses_attnums);

		/* if no suitable dependency was found, we're done */
		if (!dependency)
			break;

		/*
		 * We found an applicable dependency, so find all the clauses on the
		 * implied attribute - with dependency (a,b => c) we look for clauses
		 * on 'c'.
		 */
		listidx = -1;
		foreach(l, clauses)
		{
			Node	   *clause;

			listidx++;

			/*
			 * Skip incompatible clauses, and ones we've already estimated on.
			 */
			if (list_attnums[listidx] == InvalidAttrNumber ||
				bms_is_member(listidx, *estimatedclauses))
				continue;

			/*
			 * Technically we could find more than one clause for a given
			 * attnum. Since these clauses must be equality clauses, we choose
			 * to only take the selectivity estimate from the final clause in
			 * the list for this attnum. If the attnum happens to be compared
			 * to a different Const in another clause then no rows will match
			 * anyway. If it happens to be compared to the same Const, then
			 * ignoring the additional clause is just the thing to do.
			 */
			if (dependency_implies_attribute(dependency,
											 list_attnums[listidx]))
			{
				clause = (Node *) lfirst(l);

				s2 = clause_selectivity(root, clause, varRelid, jointype,
										sjinfo);

				/* mark this one as done, so we don't touch it again. */
				*estimatedclauses = bms_add_member(*estimatedclauses, listidx);

				/*
				 * Mark that we've got and used the dependency on this clause.
				 * We'll want to ignore this when looking for the next
				 * strongest dependency above.
				 */
				clauses_attnums = bms_del_member(clauses_attnums,
												 list_attnums[listidx]);
			}
		}

		/*
		 * Now factor in the selectivity for all the "implied" clauses into
		 * the final one, using this formula:
		 *
		 * P(a,b) = P(a) * (f + (1-f) * P(b))
		 *
		 * where 'f' is the degree of validity of the dependency.
		 */
		s1 *= (dependency->degree + (1 - dependency->degree) * s2);
	}

	pfree(dependencies);
	pfree(list_attnums);

	return s1;
}
