/*-------------------------------------------------------------------------
 *
 * execParallel.c
 *	  Support routines for parallel execution.
 *
 * Portions Copyright (c) 1996-2017, PostgreSQL Global Development Group
 * Portions Copyright (c) 1994, Regents of the University of California
 *
 * This file contains routines that are intended to support setting up,
 * using, and tearing down a ParallelContext from within the PostgreSQL
 * executor.  The ParallelContext machinery will handle starting the
 * workers and ensuring that their state generally matches that of the
 * leader; see src/backend/access/transam/README.parallel for details.
 * However, we must save and restore relevant executor state, such as
 * any ParamListInfo associated with the query, buffer usage info, and
 * the actual plan to be passed down to the worker.
 *
 * IDENTIFICATION
 *	  src/backend/executor/execParallel.c
 *
 *-------------------------------------------------------------------------
 */

#include "postgres.h"

#include "executor/execParallel.h"
#include "executor/executor.h"
#include "executor/nodeBitmapHeapscan.h"
#include "executor/nodeCustom.h"
#include "executor/nodeForeignscan.h"
#include "executor/nodeSeqscan.h"
#include "executor/nodeIndexscan.h"
#include "executor/nodeIndexonlyscan.h"
#include "executor/tqueue.h"
#include "nodes/nodeFuncs.h"
#include "optimizer/planmain.h"
#include "optimizer/planner.h"
#include "storage/spin.h"
#include "tcop/tcopprot.h"
#include "utils/dsa.h"
#include "utils/memutils.h"
#include "utils/snapmgr.h"
#include "pgstat.h"

/*
 * Magic numbers for parallel executor communication.  We use constants
 * greater than any 32-bit integer here so that values < 2^32 can be used
 * by individual parallel nodes to store their own state.
 */
#define PARALLEL_KEY_PLANNEDSTMT		UINT64CONST(0xE000000000000001)
#define PARALLEL_KEY_PARAMS				UINT64CONST(0xE000000000000002)
#define PARALLEL_KEY_BUFFER_USAGE		UINT64CONST(0xE000000000000003)
#define PARALLEL_KEY_TUPLE_QUEUE		UINT64CONST(0xE000000000000004)
#define PARALLEL_KEY_INSTRUMENTATION	UINT64CONST(0xE000000000000005)
#define PARALLEL_KEY_DSA				UINT64CONST(0xE000000000000006)
#define PARALLEL_KEY_QUERY_TEXT		UINT64CONST(0xE000000000000007)

#define PARALLEL_TUPLE_QUEUE_SIZE		65536

/*
 * DSM structure for accumulating per-PlanState instrumentation.
 *
 * instrument_options: Same meaning here as in instrument.c.
 *
 * instrument_offset: Offset, relative to the start of this structure,
 * of the first Instrumentation object.  This will depend on the length of
 * the plan_node_id array.
 *
 * num_workers: Number of workers.
 *
 * num_plan_nodes: Number of plan nodes.
 *
 * plan_node_id: Array of plan nodes for which we are gathering instrumentation
 * from parallel workers.  The length of this array is given by num_plan_nodes.
 */
struct SharedExecutorInstrumentation
{
	int			instrument_options;
	int			instrument_offset;
	int			num_workers;
	int			num_plan_nodes;
	int			plan_node_id[FLEXIBLE_ARRAY_MEMBER];
	/* array of num_plan_nodes * num_workers Instrumentation objects follows */
};
#define GetInstrumentationArray(sei) \
	(AssertVariableIsOfTypeMacro(sei, SharedExecutorInstrumentation *), \
	 (Instrumentation *) (((char *) sei) + sei->instrument_offset))

/* Context object for ExecParallelEstimate. */
typedef struct ExecParallelEstimateContext
{
	ParallelContext *pcxt;
	int			nnodes;
} ExecParallelEstimateContext;

/* Context object for ExecParallelInitializeDSM. */
typedef struct ExecParallelInitializeDSMContext
{
	ParallelContext *pcxt;
	SharedExecutorInstrumentation *instrumentation;
	int			nnodes;
} ExecParallelInitializeDSMContext;

/* Helper functions that run in the parallel leader. */
static char *ExecSerializePlan(Plan *plan, EState *estate);
static bool ExecParallelEstimate(PlanState *node,
					 ExecParallelEstimateContext *e);
static bool ExecParallelInitializeDSM(PlanState *node,
						  ExecParallelInitializeDSMContext *d);
static shm_mq_handle **ExecParallelSetupTupleQueues(ParallelContext *pcxt,
							 bool reinitialize);
static bool ExecParallelReInitializeDSM(PlanState *planstate,
							ParallelContext *pcxt);
static bool ExecParallelRetrieveInstrumentation(PlanState *planstate,
									SharedExecutorInstrumentation *instrumentation);

/* Helper function that runs in the parallel worker. */
static DestReceiver *ExecParallelGetReceiver(dsm_segment *seg, shm_toc *toc);

/*
 * Create a serialized representation of the plan to be sent to each worker.
 */
static char *
ExecSerializePlan(Plan *plan, EState *estate)
{
	PlannedStmt *pstmt;
	ListCell   *lc;

	/* We can't scribble on the original plan, so make a copy. */
	plan = copyObject(plan);

	/*
	 * The worker will start its own copy of the executor, and that copy will
	 * insert a junk filter if the toplevel node has any resjunk entries. We
	 * don't want that to happen, because while resjunk columns shouldn't be
	 * sent back to the user, here the tuples are coming back to another
	 * backend which may very well need them.  So mutate the target list
	 * accordingly.  This is sort of a hack; there might be better ways to do
	 * this...
	 */
	foreach(lc, plan->targetlist)
	{
		TargetEntry *tle = lfirst_node(TargetEntry, lc);

		tle->resjunk = false;
	}

	/*
	 * Create a dummy PlannedStmt.  Most of the fields don't need to be valid
	 * for our purposes, but the worker will need at least a minimal
	 * PlannedStmt to start the executor.
	 */
	pstmt = makeNode(PlannedStmt);
	pstmt->commandType = CMD_SELECT;
	pstmt->queryId = 0;
	pstmt->hasReturning = false;
	pstmt->hasModifyingCTE = false;
	pstmt->canSetTag = true;
	pstmt->transientPlan = false;
	pstmt->dependsOnRole = false;
	pstmt->parallelModeNeeded = false;
	pstmt->planTree = plan;
	pstmt->rtable = estate->es_range_table;
	pstmt->resultRelations = NIL;
	pstmt->nonleafResultRelations = NIL;

	/*
	 * Transfer only parallel-safe subplans, leaving a NULL "hole" in the list
	 * for unsafe ones (so that the list indexes of the safe ones are
	 * preserved).  This positively ensures that the worker won't try to run,
	 * or even do ExecInitNode on, an unsafe subplan.  That's important to
	 * protect, eg, non-parallel-aware FDWs from getting into trouble.
	 */
	pstmt->subplans = NIL;
	foreach(lc, estate->es_plannedstmt->subplans)
	{
		Plan	   *subplan = (Plan *) lfirst(lc);

		if (subplan && !subplan->parallel_safe)
			subplan = NULL;
		pstmt->subplans = lappend(pstmt->subplans, subplan);
	}

	pstmt->rewindPlanIDs = NULL;
	pstmt->rowMarks = NIL;
	pstmt->relationOids = NIL;
	pstmt->invalItems = NIL;	/* workers can't replan anyway... */
	pstmt->nParamExec = estate->es_plannedstmt->nParamExec;
	pstmt->utilityStmt = NULL;
	pstmt->stmt_location = -1;
	pstmt->stmt_len = -1;

	/* Return serialized copy of our dummy PlannedStmt. */
	return nodeToString(pstmt);
}

/*
 * Ordinary plan nodes won't do anything here, but parallel-aware plan nodes
 * may need some state which is shared across all parallel workers.  Before
 * we size the DSM, give them a chance to call shm_toc_estimate_chunk or
 * shm_toc_estimate_keys on &pcxt->estimator.
 *
 * While we're at it, count the number of PlanState nodes in the tree, so
 * we know how many SharedPlanStateInstrumentation structures we need.
 */
static bool
ExecParallelEstimate(PlanState *planstate, ExecParallelEstimateContext *e)
{
	if (planstate == NULL)
		return false;

	/* Count this node. */
	e->nnodes++;

	/* Call estimators for parallel-aware nodes. */
	if (planstate->plan->parallel_aware)
	{
		switch (nodeTag(planstate))
		{
			case T_SeqScanState:
				ExecSeqScanEstimate((SeqScanState *) planstate,
									e->pcxt);
				break;
			case T_IndexScanState:
				ExecIndexScanEstimate((IndexScanState *) planstate,
									  e->pcxt);
				break;
			case T_IndexOnlyScanState:
				ExecIndexOnlyScanEstimate((IndexOnlyScanState *) planstate,
										  e->pcxt);
				break;
			case T_ForeignScanState:
				ExecForeignScanEstimate((ForeignScanState *) planstate,
										e->pcxt);
				break;
			case T_CustomScanState:
				ExecCustomScanEstimate((CustomScanState *) planstate,
									   e->pcxt);
				break;
			case T_BitmapHeapScanState:
				ExecBitmapHeapEstimate((BitmapHeapScanState *) planstate,
									   e->pcxt);
				break;
			default:
				break;
		}
	}

	return planstate_tree_walker(planstate, ExecParallelEstimate, e);
}

/*
 * Initialize the dynamic shared memory segment that will be used to control
 * parallel execution.
 */
static bool
ExecParallelInitializeDSM(PlanState *planstate,
						  ExecParallelInitializeDSMContext *d)
{
	if (planstate == NULL)
		return false;

	/* If instrumentation is enabled, initialize slot for this node. */
	if (d->instrumentation != NULL)
		d->instrumentation->plan_node_id[d->nnodes] =
			planstate->plan->plan_node_id;

	/* Count this node. */
	d->nnodes++;

	/*
	 * Call initializers for parallel-aware plan nodes.
	 *
	 * Ordinary plan nodes won't do anything here, but parallel-aware plan
	 * nodes may need to initialize shared state in the DSM before parallel
	 * workers are available.  They can allocate the space they previously
	 * estimated using shm_toc_allocate, and add the keys they previously
	 * estimated using shm_toc_insert, in each case targeting pcxt->toc.
	 */
	if (planstate->plan->parallel_aware)
	{
		switch (nodeTag(planstate))
		{
			case T_SeqScanState:
				ExecSeqScanInitializeDSM((SeqScanState *) planstate,
										 d->pcxt);
				break;
			case T_IndexScanState:
				ExecIndexScanInitializeDSM((IndexScanState *) planstate,
										   d->pcxt);
				break;
			case T_IndexOnlyScanState:
				ExecIndexOnlyScanInitializeDSM((IndexOnlyScanState *) planstate,
											   d->pcxt);
				break;
			case T_ForeignScanState:
				ExecForeignScanInitializeDSM((ForeignScanState *) planstate,
											 d->pcxt);
				break;
			case T_CustomScanState:
				ExecCustomScanInitializeDSM((CustomScanState *) planstate,
											d->pcxt);
				break;
			case T_BitmapHeapScanState:
				ExecBitmapHeapInitializeDSM((BitmapHeapScanState *) planstate,
											d->pcxt);
				break;

			default:
				break;
		}
	}

	return planstate_tree_walker(planstate, ExecParallelInitializeDSM, d);
}

/*
 * It sets up the response queues for backend workers to return tuples
 * to the main backend and start the workers.
 */
static shm_mq_handle **
ExecParallelSetupTupleQueues(ParallelContext *pcxt, bool reinitialize)
{
	shm_mq_handle **responseq;
	char	   *tqueuespace;
	int			i;

	/* Skip this if no workers. */
	if (pcxt->nworkers == 0)
		return NULL;

	/* Allocate memory for shared memory queue handles. */
	responseq = (shm_mq_handle **)
		palloc(pcxt->nworkers * sizeof(shm_mq_handle *));

	/*
	 * If not reinitializing, allocate space from the DSM for the queues;
	 * otherwise, find the already allocated space.
	 */
	if (!reinitialize)
		tqueuespace =
			shm_toc_allocate(pcxt->toc,
							 mul_size(PARALLEL_TUPLE_QUEUE_SIZE,
									  pcxt->nworkers));
	else
		tqueuespace = shm_toc_lookup(pcxt->toc, PARALLEL_KEY_TUPLE_QUEUE, false);

	/* Create the queues, and become the receiver for each. */
	for (i = 0; i < pcxt->nworkers; ++i)
	{
		shm_mq	   *mq;

		mq = shm_mq_create(tqueuespace +
						   ((Size) i) * PARALLEL_TUPLE_QUEUE_SIZE,
						   (Size) PARALLEL_TUPLE_QUEUE_SIZE);

		shm_mq_set_receiver(mq, MyProc);
		responseq[i] = shm_mq_attach(mq, pcxt->seg, NULL);
	}

	/* Add array of queues to shm_toc, so others can find it. */
	if (!reinitialize)
		shm_toc_insert(pcxt->toc, PARALLEL_KEY_TUPLE_QUEUE, tqueuespace);

	/* Return array of handles. */
	return responseq;
}

/*
 * Sets up the required infrastructure for backend workers to perform
 * execution and return results to the main backend.
 */
ParallelExecutorInfo *
ExecInitParallelPlan(PlanState *planstate, EState *estate, int nworkers)
{
	ParallelExecutorInfo *pei;
	ParallelContext *pcxt;
	ExecParallelEstimateContext e;
	ExecParallelInitializeDSMContext d;
	char	   *pstmt_data;
	char	   *pstmt_space;
	char	   *param_space;
	BufferUsage *bufusage_space;
	SharedExecutorInstrumentation *instrumentation = NULL;
	int			pstmt_len;
	int			param_len;
	int			instrumentation_len = 0;
	int			instrument_offset = 0;
	Size		dsa_minsize = dsa_minimum_size();
	char	   *query_string;
	int			query_len;

	/* Allocate object for return value. */
	pei = palloc0(sizeof(ParallelExecutorInfo));
	pei->finished = false;
	pei->planstate = planstate;

	/* Fix up and serialize plan to be sent to workers. */
	pstmt_data = ExecSerializePlan(planstate->plan, estate);

	/* Create a parallel context. */
	pcxt = CreateParallelContext("postgres", "ParallelQueryMain", nworkers);
	pei->pcxt = pcxt;

	/*
	 * Before telling the parallel context to create a dynamic shared memory
	 * segment, we need to figure out how big it should be.  Estimate space
	 * for the various things we need to store.
	 */

	/* Estimate space for query text. */
	query_len = strlen(estate->es_sourceText);
	shm_toc_estimate_chunk(&pcxt->estimator, query_len + 1);
	shm_toc_estimate_keys(&pcxt->estimator, 1);

	/* Estimate space for serialized PlannedStmt. */
	pstmt_len = strlen(pstmt_data) + 1;
	shm_toc_estimate_chunk(&pcxt->estimator, pstmt_len);
	shm_toc_estimate_keys(&pcxt->estimator, 1);

	/* Estimate space for serialized ParamListInfo. */
	param_len = EstimateParamListSpace(estate->es_param_list_info);
	shm_toc_estimate_chunk(&pcxt->estimator, param_len);
	shm_toc_estimate_keys(&pcxt->estimator, 1);

	/*
	 * Estimate space for BufferUsage.
	 *
	 * If EXPLAIN is not in use and there are no extensions loaded that care,
	 * we could skip this.  But we have no way of knowing whether anyone's
	 * looking at pgBufferUsage, so do it unconditionally.
	 */
	shm_toc_estimate_chunk(&pcxt->estimator,
						   mul_size(sizeof(BufferUsage), pcxt->nworkers));
	shm_toc_estimate_keys(&pcxt->estimator, 1);

	/* Estimate space for tuple queues. */
	shm_toc_estimate_chunk(&pcxt->estimator,
						   mul_size(PARALLEL_TUPLE_QUEUE_SIZE, pcxt->nworkers));
	shm_toc_estimate_keys(&pcxt->estimator, 1);

	/*
	 * Give parallel-aware nodes a chance to add to the estimates, and get a
	 * count of how many PlanState nodes there are.
	 */
	e.pcxt = pcxt;
	e.nnodes = 0;
	ExecParallelEstimate(planstate, &e);

	/* Estimate space for instrumentation, if required. */
	if (estate->es_instrument)
	{
		instrumentation_len =
			offsetof(SharedExecutorInstrumentation, plan_node_id) +
			sizeof(int) * e.nnodes;
		instrumentation_len = MAXALIGN(instrumentation_len);
		instrument_offset = instrumentation_len;
		instrumentation_len +=
			mul_size(sizeof(Instrumentation),
					 mul_size(e.nnodes, nworkers));
		shm_toc_estimate_chunk(&pcxt->estimator, instrumentation_len);
		shm_toc_estimate_keys(&pcxt->estimator, 1);
	}

	/* Estimate space for DSA area. */
	shm_toc_estimate_chunk(&pcxt->estimator, dsa_minsize);
	shm_toc_estimate_keys(&pcxt->estimator, 1);

	/* Everyone's had a chance to ask for space, so now create the DSM. */
	InitializeParallelDSM(pcxt);

	/*
	 * OK, now we have a dynamic shared memory segment, and it should be big
	 * enough to store all of the data we estimated we would want to put into
	 * it, plus whatever general stuff (not specifically executor-related) the
	 * ParallelContext itself needs to store there.  None of the space we
	 * asked for has been allocated or initialized yet, though, so do that.
	 */

	/* Store query string */
	query_string = shm_toc_allocate(pcxt->toc, query_len + 1);
	memcpy(query_string, estate->es_sourceText, query_len + 1);
	shm_toc_insert(pcxt->toc, PARALLEL_KEY_QUERY_TEXT, query_string);

	/* Store serialized PlannedStmt. */
	pstmt_space = shm_toc_allocate(pcxt->toc, pstmt_len);
	memcpy(pstmt_space, pstmt_data, pstmt_len);
	shm_toc_insert(pcxt->toc, PARALLEL_KEY_PLANNEDSTMT, pstmt_space);

	/* Store serialized ParamListInfo. */
	param_space = shm_toc_allocate(pcxt->toc, param_len);
	shm_toc_insert(pcxt->toc, PARALLEL_KEY_PARAMS, param_space);
	SerializeParamList(estate->es_param_list_info, &param_space);

	/* Allocate space for each worker's BufferUsage; no need to initialize. */
	bufusage_space = shm_toc_allocate(pcxt->toc,
									  mul_size(sizeof(BufferUsage), pcxt->nworkers));
	shm_toc_insert(pcxt->toc, PARALLEL_KEY_BUFFER_USAGE, bufusage_space);
	pei->buffer_usage = bufusage_space;

	/* Set up the tuple queues that the workers will write into. */
	pei->tqueue = ExecParallelSetupTupleQueues(pcxt, false);

	/* We don't need the TupleQueueReaders yet, though. */
	pei->reader = NULL;

	/*
	 * If instrumentation options were supplied, allocate space for the data.
	 * It only gets partially initialized here; the rest happens during
	 * ExecParallelInitializeDSM.
	 */
	if (estate->es_instrument)
	{
		Instrumentation *instrument;
		int			i;

		instrumentation = shm_toc_allocate(pcxt->toc, instrumentation_len);
		instrumentation->instrument_options = estate->es_instrument;
		instrumentation->instrument_offset = instrument_offset;
		instrumentation->num_workers = nworkers;
		instrumentation->num_plan_nodes = e.nnodes;
		instrument = GetInstrumentationArray(instrumentation);
		for (i = 0; i < nworkers * e.nnodes; ++i)
			InstrInit(&instrument[i], estate->es_instrument);
		shm_toc_insert(pcxt->toc, PARALLEL_KEY_INSTRUMENTATION,
					   instrumentation);
		pei->instrumentation = instrumentation;
	}

	/*
	 * Create a DSA area that can be used by the leader and all workers.
	 * (However, if we failed to create a DSM and are using private memory
	 * instead, then skip this.)
	 */
	if (pcxt->seg != NULL)
	{
		char	   *area_space;

		area_space = shm_toc_allocate(pcxt->toc, dsa_minsize);
		shm_toc_insert(pcxt->toc, PARALLEL_KEY_DSA, area_space);
		pei->area = dsa_create_in_place(area_space, dsa_minsize,
										LWTRANCHE_PARALLEL_QUERY_DSA,
										pcxt->seg);
	}

	/*
	 * Give parallel-aware nodes a chance to initialize their shared data.
	 * This also initializes the elements of instrumentation->ps_instrument,
	 * if it exists.
	 */
	d.pcxt = pcxt;
	d.instrumentation = instrumentation;
	d.nnodes = 0;

	/* Install our DSA area while initializing the plan. */
	estate->es_query_dsa = pei->area;
	ExecParallelInitializeDSM(planstate, &d);
	estate->es_query_dsa = NULL;

	/*
	 * Make sure that the world hasn't shifted under our feet.  This could
	 * probably just be an Assert(), but let's be conservative for now.
	 */
	if (e.nnodes != d.nnodes)
		elog(ERROR, "inconsistent count of PlanState nodes");

	/* OK, we're ready to rock and roll. */
	return pei;
}

/*
 * Set up tuple queue readers to read the results of a parallel subplan.
 * All the workers are expected to return tuples matching tupDesc.
 *
 * This is separate from ExecInitParallelPlan() because we can launch the
 * worker processes and let them start doing something before we do this.
 */
void
ExecParallelCreateReaders(ParallelExecutorInfo *pei,
						  TupleDesc tupDesc)
{
	int			nworkers = pei->pcxt->nworkers_launched;
	int			i;

	Assert(pei->reader == NULL);

	if (nworkers > 0)
	{
		pei->reader = (TupleQueueReader **)
			palloc(nworkers * sizeof(TupleQueueReader *));

		for (i = 0; i < nworkers; i++)
		{
			shm_mq_set_handle(pei->tqueue[i],
							  pei->pcxt->worker[i].bgwhandle);
			pei->reader[i] = CreateTupleQueueReader(pei->tqueue[i],
													tupDesc);
		}
	}
}

/*
 * Re-initialize the parallel executor shared memory state before launching
 * a fresh batch of workers.
 */
void
ExecParallelReinitialize(PlanState *planstate,
						 ParallelExecutorInfo *pei)
{
	EState	   *estate = planstate->state;

	/* Old workers must already be shut down */
	Assert(pei->finished);

	ReinitializeParallelDSM(pei->pcxt);
	pei->tqueue = ExecParallelSetupTupleQueues(pei->pcxt, true);
	pei->reader = NULL;
	pei->finished = false;

	/* Traverse plan tree and let each child node reset associated state. */
	estate->es_query_dsa = pei->area;
	ExecParallelReInitializeDSM(planstate, pei->pcxt);
	estate->es_query_dsa = NULL;
}

/*
 * Traverse plan tree to reinitialize per-node dynamic shared memory state
 */
static bool
ExecParallelReInitializeDSM(PlanState *planstate,
							ParallelContext *pcxt)
{
	if (planstate == NULL)
		return false;

	/*
	 * Call reinitializers for DSM-using plan nodes.
	 */
	if (planstate->plan->parallel_aware)
	{
		switch (nodeTag(planstate))
		{
			case T_SeqScanState:
				ExecSeqScanReInitializeDSM((SeqScanState *) planstate,
										   pcxt);
				break;
			case T_IndexScanState:
				ExecIndexScanReInitializeDSM((IndexScanState *) planstate,
											 pcxt);
				break;
			case T_IndexOnlyScanState:
				ExecIndexOnlyScanReInitializeDSM((IndexOnlyScanState *) planstate,
												 pcxt);
				break;
			case T_ForeignScanState:
				ExecForeignScanReInitializeDSM((ForeignScanState *) planstate,
											   pcxt);
				break;
			case T_CustomScanState:
				ExecCustomScanReInitializeDSM((CustomScanState *) planstate,
											  pcxt);
				break;
			case T_BitmapHeapScanState:
				ExecBitmapHeapReInitializeDSM((BitmapHeapScanState *) planstate,
											  pcxt);
				break;

			default:
				break;
		}
	}

	return planstate_tree_walker(planstate, ExecParallelReInitializeDSM, pcxt);
}

/*
 * Copy instrumentation information about this node and its descendants from
 * dynamic shared memory.
 */
static bool
ExecParallelRetrieveInstrumentation(PlanState *planstate,
									SharedExecutorInstrumentation *instrumentation)
{
	Instrumentation *instrument;
	int			i;
	int			n;
	int			ibytes;
	int			plan_node_id = planstate->plan->plan_node_id;
	MemoryContext oldcontext;

	/* Find the instrumentation for this node. */
	for (i = 0; i < instrumentation->num_plan_nodes; ++i)
		if (instrumentation->plan_node_id[i] == plan_node_id)
			break;
	if (i >= instrumentation->num_plan_nodes)
		elog(ERROR, "plan node %d not found", plan_node_id);

	/* Accumulate the statistics from all workers. */
	instrument = GetInstrumentationArray(instrumentation);
	instrument += i * instrumentation->num_workers;
	for (n = 0; n < instrumentation->num_workers; ++n)
		InstrAggNode(planstate->instrument, &instrument[n]);

	/*
	 * Also store the per-worker detail.
	 *
	 * Worker instrumentation should be allocated in the same context as the
	 * regular instrumentation information, which is the per-query context.
	 * Switch into per-query memory context.
	 */
	oldcontext = MemoryContextSwitchTo(planstate->state->es_query_cxt);
	ibytes = mul_size(instrumentation->num_workers, sizeof(Instrumentation));
	planstate->worker_instrument =
		palloc(ibytes + offsetof(WorkerInstrumentation, instrument));
	MemoryContextSwitchTo(oldcontext);

	planstate->worker_instrument->num_workers = instrumentation->num_workers;
	memcpy(&planstate->worker_instrument->instrument, instrument, ibytes);

	return planstate_tree_walker(planstate, ExecParallelRetrieveInstrumentation,
								 instrumentation);
}

/*
 * Finish parallel execution.  We wait for parallel workers to finish, and
 * accumulate their buffer usage.
 */
void
ExecParallelFinish(ParallelExecutorInfo *pei)
{
	int			nworkers = pei->pcxt->nworkers_launched;
	int			i;

	/* Make this be a no-op if called twice in a row. */
	if (pei->finished)
		return;

	/*
	 * Detach from tuple queues ASAP, so that any still-active workers will
	 * notice that no further results are wanted.
	 */
	if (pei->tqueue != NULL)
	{
		for (i = 0; i < nworkers; i++)
			shm_mq_detach(pei->tqueue[i]);
		pfree(pei->tqueue);
		pei->tqueue = NULL;
	}

	/*
	 * While we're waiting for the workers to finish, let's get rid of the
	 * tuple queue readers.  (Any other local cleanup could be done here too.)
	 */
	if (pei->reader != NULL)
	{
		for (i = 0; i < nworkers; i++)
			DestroyTupleQueueReader(pei->reader[i]);
		pfree(pei->reader);
		pei->reader = NULL;
	}

	/* Now wait for the workers to finish. */
	WaitForParallelWorkersToFinish(pei->pcxt);

	/*
	 * Next, accumulate buffer usage.  (This must wait for the workers to
	 * finish, or we might get incomplete data.)
	 */
	for (i = 0; i < nworkers; i++)
		InstrAccumParallelQuery(&pei->buffer_usage[i]);

	pei->finished = true;
}

/*
 * Accumulate instrumentation, and then clean up whatever ParallelExecutorInfo
 * resources still exist after ExecParallelFinish.  We separate these
 * routines because someone might want to examine the contents of the DSM
 * after ExecParallelFinish and before calling this routine.
 */
void
ExecParallelCleanup(ParallelExecutorInfo *pei)
{
	/* Accumulate instrumentation, if any. */
	if (pei->instrumentation)
		ExecParallelRetrieveInstrumentation(pei->planstate,
											pei->instrumentation);

	if (pei->area != NULL)
	{
		dsa_detach(pei->area);
		pei->area = NULL;
	}
	if (pei->pcxt != NULL)
	{
		DestroyParallelContext(pei->pcxt);
		pei->pcxt = NULL;
	}
	pfree(pei);
}

/*
 * Create a DestReceiver to write tuples we produce to the shm_mq designated
 * for that purpose.
 */
static DestReceiver *
ExecParallelGetReceiver(dsm_segment *seg, shm_toc *toc)
{
	char	   *mqspace;
	shm_mq	   *mq;

	mqspace = shm_toc_lookup(toc, PARALLEL_KEY_TUPLE_QUEUE, false);
	mqspace += ParallelWorkerNumber * PARALLEL_TUPLE_QUEUE_SIZE;
	mq = (shm_mq *) mqspace;
	shm_mq_set_sender(mq, MyProc);
	return CreateTupleQueueDestReceiver(shm_mq_attach(mq, seg, NULL));
}

/*
 * Create a QueryDesc for the PlannedStmt we are to execute, and return it.
 */
static QueryDesc *
ExecParallelGetQueryDesc(shm_toc *toc, DestReceiver *receiver,
						 int instrument_options)
{
	char	   *pstmtspace;
	char	   *paramspace;
	PlannedStmt *pstmt;
	ParamListInfo paramLI;
	char	   *queryString;

	/* Get the query string from shared memory */
	queryString = shm_toc_lookup(toc, PARALLEL_KEY_QUERY_TEXT, false);

	/* Reconstruct leader-supplied PlannedStmt. */
	pstmtspace = shm_toc_lookup(toc, PARALLEL_KEY_PLANNEDSTMT, false);
	pstmt = (PlannedStmt *) stringToNode(pstmtspace);

	/* Reconstruct ParamListInfo. */
	paramspace = shm_toc_lookup(toc, PARALLEL_KEY_PARAMS, false);
	paramLI = RestoreParamList(&paramspace);

	/*
	 * Create a QueryDesc for the query.
	 *
	 * It's not obvious how to obtain the query string from here; and even if
	 * we could copying it would take more cycles than not copying it. But
	 * it's a bit unsatisfying to just use a dummy string here, so consider
	 * revising this someday.
	 */
	return CreateQueryDesc(pstmt,
						   queryString,
						   GetActiveSnapshot(), InvalidSnapshot,
						   receiver, paramLI, NULL, instrument_options);
}

/*
 * Copy instrumentation information from this node and its descendants into
 * dynamic shared memory, so that the parallel leader can retrieve it.
 */
static bool
ExecParallelReportInstrumentation(PlanState *planstate,
								  SharedExecutorInstrumentation *instrumentation)
{
	int			i;
	int			plan_node_id = planstate->plan->plan_node_id;
	Instrumentation *instrument;

	InstrEndLoop(planstate->instrument);

	/*
	 * If we shuffled the plan_node_id values in ps_instrument into sorted
	 * order, we could use binary search here.  This might matter someday if
	 * we're pushing down sufficiently large plan trees.  For now, do it the
	 * slow, dumb way.
	 */
	for (i = 0; i < instrumentation->num_plan_nodes; ++i)
		if (instrumentation->plan_node_id[i] == plan_node_id)
			break;
	if (i >= instrumentation->num_plan_nodes)
		elog(ERROR, "plan node %d not found", plan_node_id);

	/*
	 * Add our statistics to the per-node, per-worker totals.  It's possible
	 * that this could happen more than once if we relaunched workers.
	 */
	instrument = GetInstrumentationArray(instrumentation);
	instrument += i * instrumentation->num_workers;
	Assert(IsParallelWorker());
	Assert(ParallelWorkerNumber < instrumentation->num_workers);
	InstrAggNode(&instrument[ParallelWorkerNumber], planstate->instrument);

	return planstate_tree_walker(planstate, ExecParallelReportInstrumentation,
								 instrumentation);
}

/*
 * Initialize the PlanState and its descendants with the information
 * retrieved from shared memory.  This has to be done once the PlanState
 * is allocated and initialized by executor; that is, after ExecutorStart().
 */
static bool
ExecParallelInitializeWorker(PlanState *planstate, shm_toc *toc)
{
	if (planstate == NULL)
		return false;

	/* Call initializers for parallel-aware plan nodes. */
	if (planstate->plan->parallel_aware)
	{
		switch (nodeTag(planstate))
		{
			case T_SeqScanState:
				ExecSeqScanInitializeWorker((SeqScanState *) planstate, toc);
				break;
			case T_IndexScanState:
				ExecIndexScanInitializeWorker((IndexScanState *) planstate, toc);
				break;
			case T_IndexOnlyScanState:
				ExecIndexOnlyScanInitializeWorker((IndexOnlyScanState *) planstate, toc);
				break;
			case T_ForeignScanState:
				ExecForeignScanInitializeWorker((ForeignScanState *) planstate,
												toc);
				break;
			case T_CustomScanState:
				ExecCustomScanInitializeWorker((CustomScanState *) planstate,
											   toc);
				break;
			case T_BitmapHeapScanState:
				ExecBitmapHeapInitializeWorker(
											   (BitmapHeapScanState *) planstate, toc);
				break;
			default:
				break;
		}
	}

	return planstate_tree_walker(planstate, ExecParallelInitializeWorker, toc);
}

/*
 * Main entrypoint for parallel query worker processes.
 *
 * We reach this function from ParallelWorkerMain, so the setup necessary to
 * create a sensible parallel environment has already been done;
 * ParallelWorkerMain worries about stuff like the transaction state, combo
 * CID mappings, and GUC values, so we don't need to deal with any of that
 * here.
 *
 * Our job is to deal with concerns specific to the executor.  The parallel
 * group leader will have stored a serialized PlannedStmt, and it's our job
 * to execute that plan and write the resulting tuples to the appropriate
 * tuple queue.  Various bits of supporting information that we need in order
 * to do this are also stored in the dsm_segment and can be accessed through
 * the shm_toc.
 */
void
ParallelQueryMain(dsm_segment *seg, shm_toc *toc)
{
	BufferUsage *buffer_usage;
	DestReceiver *receiver;
	QueryDesc  *queryDesc;
	SharedExecutorInstrumentation *instrumentation;
	int			instrument_options = 0;
	void	   *area_space;
	dsa_area   *area;

	/* Set up DestReceiver, SharedExecutorInstrumentation, and QueryDesc. */
	receiver = ExecParallelGetReceiver(seg, toc);
	instrumentation = shm_toc_lookup(toc, PARALLEL_KEY_INSTRUMENTATION, true);
	if (instrumentation != NULL)
		instrument_options = instrumentation->instrument_options;
	queryDesc = ExecParallelGetQueryDesc(toc, receiver, instrument_options);

	/* Setting debug_query_string for individual workers */
	debug_query_string = queryDesc->sourceText;

	/* Report workers' query for monitoring purposes */
	pgstat_report_activity(STATE_RUNNING, debug_query_string);

	/* Prepare to track buffer usage during query execution. */
	InstrStartParallelQuery();

	/* Attach to the dynamic shared memory area. */
	area_space = shm_toc_lookup(toc, PARALLEL_KEY_DSA, false);
	area = dsa_attach_in_place(area_space, seg);

	/* Start up the executor */
	ExecutorStart(queryDesc, 0);

	/* Special executor initialization steps for parallel workers */
	queryDesc->planstate->state->es_query_dsa = area;
	ExecParallelInitializeWorker(queryDesc->planstate, toc);

	/* Run the plan */
	ExecutorRun(queryDesc, ForwardScanDirection, 0L, true);

	/* Shut down the executor */
	ExecutorFinish(queryDesc);

	/* Report buffer usage during parallel execution. */
	buffer_usage = shm_toc_lookup(toc, PARALLEL_KEY_BUFFER_USAGE, false);
	InstrEndParallelQuery(&buffer_usage[ParallelWorkerNumber]);

	/* Report instrumentation data if any instrumentation options are set. */
	if (instrumentation != NULL)
		ExecParallelReportInstrumentation(queryDesc->planstate,
										  instrumentation);

	/* Must do this after capturing instrumentation. */
	ExecutorEnd(queryDesc);

	/* Cleanup. */
	dsa_detach(area);
	FreeQueryDesc(queryDesc);
	(*receiver->rDestroy) (receiver);
}
