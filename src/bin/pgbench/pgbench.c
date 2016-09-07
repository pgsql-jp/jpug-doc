/*
 * pgbench.c
 *
 * A simple benchmark program for PostgreSQL
 * Originally written by Tatsuo Ishii and enhanced by many contributors.
 *
 * src/bin/pgbench/pgbench.c
 * Copyright (c) 2000-2016, PostgreSQL Global Development Group
 * ALL RIGHTS RESERVED;
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without a written agreement
 * is hereby granted, provided that the above copyright notice and this
 * paragraph and the following two paragraphs appear in all copies.
 *
 * IN NO EVENT SHALL THE AUTHOR OR DISTRIBUTORS BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING
 * LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
 * DOCUMENTATION, EVEN IF THE AUTHOR OR DISTRIBUTORS HAVE BEEN ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * THE AUTHOR AND DISTRIBUTORS SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE AUTHOR AND DISTRIBUTORS HAS NO OBLIGATIONS TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 */

#ifdef WIN32
#define FD_SETSIZE 1024			/* set before winsock2.h is included */
#endif   /* ! WIN32 */

#include "postgres_fe.h"

#include "getopt_long.h"
#include "libpq-fe.h"
#include "portability/instr_time.h"

#include <ctype.h>
#include <float.h>
#include <limits.h>
#include <math.h>
#include <signal.h>
#include <sys/time.h>
#ifdef HAVE_SYS_SELECT_H
#include <sys/select.h>
#endif

#ifdef HAVE_SYS_RESOURCE_H
#include <sys/resource.h>		/* for getrlimit */
#endif

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

#include "pgbench.h"

#define ERRCODE_UNDEFINED_TABLE  "42P01"

/*
 * Multi-platform pthread implementations
 */

#ifdef WIN32
/* Use native win32 threads on Windows */
typedef struct win32_pthread *pthread_t;
typedef int pthread_attr_t;

static int	pthread_create(pthread_t *thread, pthread_attr_t *attr, void *(*start_routine) (void *), void *arg);
static int	pthread_join(pthread_t th, void **thread_return);
#elif defined(ENABLE_THREAD_SAFETY)
/* Use platform-dependent pthread capability */
#include <pthread.h>
#else
/* No threads implementation, use none (-j 1) */
#define pthread_t void *
#endif


/********************************************************************
 * some configurable parameters */

/* max number of clients allowed */
#ifdef FD_SETSIZE
#define MAXCLIENTS	(FD_SETSIZE - 10)
#else
#define MAXCLIENTS	1024
#endif

#define LOG_STEP_SECONDS	5	/* seconds between log messages */
#define DEFAULT_NXACTS	10		/* default nxacts */

#define MIN_GAUSSIAN_PARAM		2.0		/* minimum parameter for gauss */

int			nxacts = 0;			/* number of transactions per client */
int			duration = 0;		/* duration in seconds */
int64		end_time = 0;		/* when to stop in micro seconds, under -T */

/*
 * scaling factor. for example, scale = 10 will make 1000000 tuples in
 * pgbench_accounts table.
 */
int			scale = 1;

/*
 * fillfactor. for example, fillfactor = 90 will use only 90 percent
 * space during inserts and leave 10 percent free.
 */
int			fillfactor = 100;

/*
 * create foreign key constraints on the tables?
 */
int			foreign_keys = 0;

/*
 * use unlogged tables?
 */
int			unlogged_tables = 0;

/*
 * log sampling rate (1.0 = log everything, 0.0 = option not given)
 */
double		sample_rate = 0.0;

/*
 * When threads are throttled to a given rate limit, this is the target delay
 * to reach that rate in usec.  0 is the default and means no throttling.
 */
int64		throttle_delay = 0;

/*
 * Transactions which take longer than this limit (in usec) are counted as
 * late, and reported as such, although they are completed anyway. When
 * throttling is enabled, execution time slots that are more than this late
 * are skipped altogether, and counted separately.
 */
int64		latency_limit = 0;

/*
 * tablespace selection
 */
char	   *tablespace = NULL;
char	   *index_tablespace = NULL;

/*
 * end of configurable parameters
 *********************************************************************/

#define nbranches	1			/* Makes little sense to change this.  Change
								 * -s instead */
#define ntellers	10
#define naccounts	100000

/*
 * The scale factor at/beyond which 32bit integers are incapable of storing
 * 64bit values.
 *
 * Although the actual threshold is 21474, we use 20000 because it is easier to
 * document and remember, and isn't that far away from the real threshold.
 */
#define SCALE_32BIT_THRESHOLD 20000

bool		use_log;			/* log transaction latencies to a file */
bool		use_quiet;			/* quiet logging onto stderr */
int			agg_interval;		/* log aggregates instead of individual
								 * transactions */
bool		per_script_stats = false;	/* whether to collect stats per script */
int			progress = 0;		/* thread progress report every this seconds */
bool		progress_timestamp = false; /* progress report with Unix time */
int			nclients = 1;		/* number of clients */
int			nthreads = 1;		/* number of threads */
bool		is_connect;			/* establish connection for each transaction */
bool		is_latencies;		/* report per-command latencies */
int			main_pid;			/* main process id used in log filename */

char	   *pghost = "";
char	   *pgport = "";
char	   *login = NULL;
char	   *dbName;
const char *progname;

#define WSEP '@'				/* weight separator */

volatile bool timer_exceeded = false;	/* flag from signal handler */

/*
 * Variable definitions.  If a variable has a string value, "value" is that
 * value, is_numeric is false, and num_value is undefined.  If the value is
 * known to be numeric, is_numeric is true and num_value contains the value
 * (in any permitted numeric variant).  In this case "value" contains the
 * string equivalent of the number, if we've had occasion to compute that,
 * or NULL if we haven't.
 */
typedef struct
{
	char	   *name;			/* variable's name */
	char	   *value;			/* its value in string form, if known */
	bool		is_numeric;		/* is numeric value known? */
	PgBenchValue num_value;		/* variable's value in numeric form */
} Variable;

#define MAX_SCRIPTS		128		/* max number of SQL scripts allowed */
#define SHELL_COMMAND_SIZE	256 /* maximum size allowed for shell command */

/*
 * Simple data structure to keep stats about something.
 *
 * XXX probably the first value should be kept and used as an offset for
 * better numerical stability...
 */
typedef struct SimpleStats
{
	int64		count;			/* how many values were encountered */
	double		min;			/* the minimum seen */
	double		max;			/* the maximum seen */
	double		sum;			/* sum of values */
	double		sum2;			/* sum of squared values */
} SimpleStats;

/*
 * Data structure to hold various statistics: per-thread and per-script stats
 * are maintained and merged together.
 */
typedef struct StatsData
{
	long		start_time;		/* interval start time, for aggregates */
	int64		cnt;			/* number of transactions */
	int64		skipped;		/* number of transactions skipped under --rate
								 * and --latency-limit */
	SimpleStats latency;
	SimpleStats lag;
} StatsData;

/*
 * Connection state
 */
typedef struct
{
	PGconn	   *con;			/* connection handle to DB */
	int			id;				/* client No. */
	int			state;			/* state No. */
	bool		listen;			/* whether an async query has been sent */
	bool		sleeping;		/* whether the client is napping */
	bool		throttling;		/* whether nap is for throttling */
	bool		is_throttled;	/* whether transaction throttling is done */
	Variable   *variables;		/* array of variable definitions */
	int			nvariables;		/* number of variables */
	bool		vars_sorted;	/* are variables sorted by name? */
	int64		txn_scheduled;	/* scheduled start time of transaction (usec) */
	instr_time	txn_begin;		/* used for measuring schedule lag times */
	instr_time	stmt_begin;		/* used for measuring statement latencies */
	int			use_file;		/* index in sql_scripts for this client */
	bool		prepared[MAX_SCRIPTS];	/* whether client prepared the script */

	/* per client collected stats */
	int64		cnt;			/* transaction count */
	int			ecnt;			/* error count */
} CState;

/*
 * Thread state
 */
typedef struct
{
	int			tid;			/* thread id */
	pthread_t	thread;			/* thread handle */
	CState	   *state;			/* array of CState */
	int			nstate;			/* length of state[] */
	unsigned short random_state[3];		/* separate randomness for each thread */
	int64		throttle_trigger;		/* previous/next throttling (us) */
	FILE	   *logfile;		/* where to log, or NULL */

	/* per thread collected stats */
	instr_time	start_time;		/* thread start time */
	instr_time	conn_time;
	StatsData	stats;
	int64		latency_late;	/* executed but late transactions */
} TState;

#define INVALID_THREAD		((pthread_t) 0)

/*
 * queries read from files
 */
#define SQL_COMMAND		1
#define META_COMMAND	2
#define MAX_ARGS		10

typedef enum QueryMode
{
	QUERY_SIMPLE,				/* simple query */
	QUERY_EXTENDED,				/* extended query */
	QUERY_PREPARED,				/* extended query with prepared statements */
	NUM_QUERYMODE
} QueryMode;

static QueryMode querymode = QUERY_SIMPLE;
static const char *QUERYMODE[] = {"simple", "extended", "prepared"};

typedef struct
{
	char	   *line;			/* text of command line */
	int			command_num;	/* unique index of this Command struct */
	int			type;			/* command type (SQL_COMMAND or META_COMMAND) */
	int			argc;			/* number of command words */
	char	   *argv[MAX_ARGS]; /* command word list */
	PgBenchExpr *expr;			/* parsed expression, if needed */
	SimpleStats stats;			/* time spent in this command */
} Command;

typedef struct ParsedScript
{
	const char *desc;			/* script descriptor (eg, file name) */
	int			weight;			/* selection weight */
	Command   **commands;		/* NULL-terminated array of Commands */
	StatsData	stats;			/* total time spent in script */
} ParsedScript;

static ParsedScript sql_script[MAX_SCRIPTS];	/* SQL script files */
static int	num_scripts;		/* number of scripts in sql_script[] */
static int	num_commands = 0;	/* total number of Command structs */
static int64 total_weight = 0;

static int	debug = 0;			/* debug flag */

/* Builtin test scripts */
typedef struct BuiltinScript
{
	const char *name;			/* very short name for -b ... */
	const char *desc;			/* short description */
	const char *script;			/* actual pgbench script */
} BuiltinScript;

static const BuiltinScript builtin_script[] =
{
	{
		"tpcb-like",
		"<builtin: TPC-B (sort of)>",
		"\\set aid random(1, " CppAsString2(naccounts) " * :scale)\n"
		"\\set bid random(1, " CppAsString2(nbranches) " * :scale)\n"
		"\\set tid random(1, " CppAsString2(ntellers) " * :scale)\n"
		"\\set delta random(-5000, 5000)\n"
		"BEGIN;\n"
		"UPDATE pgbench_accounts SET abalance = abalance + :delta WHERE aid = :aid;\n"
		"SELECT abalance FROM pgbench_accounts WHERE aid = :aid;\n"
		"UPDATE pgbench_tellers SET tbalance = tbalance + :delta WHERE tid = :tid;\n"
		"UPDATE pgbench_branches SET bbalance = bbalance + :delta WHERE bid = :bid;\n"
		"INSERT INTO pgbench_history (tid, bid, aid, delta, mtime) VALUES (:tid, :bid, :aid, :delta, CURRENT_TIMESTAMP);\n"
		"END;\n"
	},
	{
		"simple-update",
		"<builtin: simple update>",
		"\\set aid random(1, " CppAsString2(naccounts) " * :scale)\n"
		"\\set bid random(1, " CppAsString2(nbranches) " * :scale)\n"
		"\\set tid random(1, " CppAsString2(ntellers) " * :scale)\n"
		"\\set delta random(-5000, 5000)\n"
		"BEGIN;\n"
		"UPDATE pgbench_accounts SET abalance = abalance + :delta WHERE aid = :aid;\n"
		"SELECT abalance FROM pgbench_accounts WHERE aid = :aid;\n"
		"INSERT INTO pgbench_history (tid, bid, aid, delta, mtime) VALUES (:tid, :bid, :aid, :delta, CURRENT_TIMESTAMP);\n"
		"END;\n"
	},
	{
		"select-only",
		"<builtin: select only>",
		"\\set aid random(1, " CppAsString2(naccounts) " * :scale)\n"
		"SELECT abalance FROM pgbench_accounts WHERE aid = :aid;\n"
	}
};


/* Function prototypes */
static void setIntValue(PgBenchValue *pv, int64 ival);
static void setDoubleValue(PgBenchValue *pv, double dval);
static bool evaluateExpr(TState *, CState *, PgBenchExpr *, PgBenchValue *);
static void doLog(TState *thread, CState *st, instr_time *now,
	  StatsData *agg, bool skipped, double latency, double lag);
static void processXactStats(TState *thread, CState *st, instr_time *now,
				 bool skipped, StatsData *agg);
static void pgbench_error(const char *fmt,...) pg_attribute_printf(1, 2);
static void addScript(ParsedScript script);
static void *threadRun(void *arg);
static void setalarm(int seconds);


/* callback functions for our flex lexer */
static const PsqlScanCallbacks pgbench_callbacks = {
	NULL,						/* don't need get_variable functionality */
	pgbench_error
};


static void
usage(void)
{
	printf("%s is a benchmarking tool for PostgreSQL.\n\n"
		   "Usage:\n"
		   "  %s [OPTION]... [DBNAME]\n"
		   "\nInitialization options:\n"
		   "  -i, --initialize         invokes initialization mode\n"
		   "  -F, --fillfactor=NUM     set fill factor\n"
		"  -n, --no-vacuum          do not run VACUUM after initialization\n"
	"  -q, --quiet              quiet logging (one message each 5 seconds)\n"
		   "  -s, --scale=NUM          scaling factor\n"
		   "  --foreign-keys           create foreign key constraints between tables\n"
		   "  --index-tablespace=TABLESPACE\n"
	"                           create indexes in the specified tablespace\n"
	 "  --tablespace=TABLESPACE  create tables in the specified tablespace\n"
		   "  --unlogged-tables        create tables as unlogged tables\n"
		   "\nOptions to select what to run:\n"
		   "  -b, --builtin=NAME[@W]   add builtin script NAME weighted at W (default: 1)\n"
	"                           (use \"-b list\" to list available scripts)\n"
		   "  -f, --file=FILENAME[@W]  add script FILENAME weighted at W (default: 1)\n"
		   "  -N, --skip-some-updates  skip updates of pgbench_tellers and pgbench_branches\n"
		   "                           (same as \"-b simple-update\")\n"
		   "  -S, --select-only        perform SELECT-only transactions\n"
		   "                           (same as \"-b select-only\")\n"
		   "\nBenchmarking options:\n"
		   "  -c, --client=NUM         number of concurrent database clients (default: 1)\n"
		   "  -C, --connect            establish new connection for each transaction\n"
		   "  -D, --define=VARNAME=VALUE\n"
	  "                           define variable for use by custom script\n"
		   "  -j, --jobs=NUM           number of threads (default: 1)\n"
		   "  -l, --log                write transaction times to log file\n"
		   "  -L, --latency-limit=NUM  count transactions lasting more than NUM ms as late\n"
		   "  -M, --protocol=simple|extended|prepared\n"
		   "                           protocol for submitting queries (default: simple)\n"
		   "  -n, --no-vacuum          do not run VACUUM before tests\n"
		   "  -P, --progress=NUM       show thread progress report every NUM seconds\n"
		   "  -r, --report-latencies   report average latency per command\n"
		"  -R, --rate=NUM           target rate in transactions per second\n"
		   "  -s, --scale=NUM          report this scale factor in output\n"
		   "  -t, --transactions=NUM   number of transactions each client runs (default: 10)\n"
		 "  -T, --time=NUM           duration of benchmark test in seconds\n"
		   "  -v, --vacuum-all         vacuum all four standard tables before tests\n"
		   "  --aggregate-interval=NUM aggregate data over NUM seconds\n"
		"  --progress-timestamp     use Unix epoch timestamps for progress\n"
		   "  --sampling-rate=NUM      fraction of transactions to log (e.g., 0.01 for 1%%)\n"
		   "\nCommon options:\n"
		   "  -d, --debug              print debugging output\n"
	  "  -h, --host=HOSTNAME      database server host or socket directory\n"
		   "  -p, --port=PORT          database server port number\n"
		   "  -U, --username=USERNAME  connect as specified database user\n"
		 "  -V, --version            output version information, then exit\n"
		   "  -?, --help               show this help, then exit\n"
		   "\n"
		   "Report bugs to <pgsql-bugs@postgresql.org>.\n",
		   progname, progname);
}

/* return whether str matches "^\s*[-+]?[0-9]+$" */
static bool
is_an_int(const char *str)
{
	const char *ptr = str;

	/* skip leading spaces; cast is consistent with strtoint64 */
	while (*ptr && isspace((unsigned char) *ptr))
		ptr++;

	/* skip sign */
	if (*ptr == '+' || *ptr == '-')
		ptr++;

	/* at least one digit */
	if (*ptr && !isdigit((unsigned char) *ptr))
		return false;

	/* eat all digits */
	while (*ptr && isdigit((unsigned char) *ptr))
		ptr++;

	/* must have reached end of string */
	return *ptr == '\0';
}


/*
 * strtoint64 -- convert a string to 64-bit integer
 *
 * This function is a modified version of scanint8() from
 * src/backend/utils/adt/int8.c.
 */
int64
strtoint64(const char *str)
{
	const char *ptr = str;
	int64		result = 0;
	int			sign = 1;

	/*
	 * Do our own scan, rather than relying on sscanf which might be broken
	 * for long long.
	 */

	/* skip leading spaces */
	while (*ptr && isspace((unsigned char) *ptr))
		ptr++;

	/* handle sign */
	if (*ptr == '-')
	{
		ptr++;

		/*
		 * Do an explicit check for INT64_MIN.  Ugly though this is, it's
		 * cleaner than trying to get the loop below to handle it portably.
		 */
		if (strncmp(ptr, "9223372036854775808", 19) == 0)
		{
			result = PG_INT64_MIN;
			ptr += 19;
			goto gotdigits;
		}
		sign = -1;
	}
	else if (*ptr == '+')
		ptr++;

	/* require at least one digit */
	if (!isdigit((unsigned char) *ptr))
		fprintf(stderr, "invalid input syntax for integer: \"%s\"\n", str);

	/* process digits */
	while (*ptr && isdigit((unsigned char) *ptr))
	{
		int64		tmp = result * 10 + (*ptr++ - '0');

		if ((tmp / 10) != result)		/* overflow? */
			fprintf(stderr, "value \"%s\" is out of range for type bigint\n", str);
		result = tmp;
	}

gotdigits:

	/* allow trailing whitespace, but not other trailing chars */
	while (*ptr != '\0' && isspace((unsigned char) *ptr))
		ptr++;

	if (*ptr != '\0')
		fprintf(stderr, "invalid input syntax for integer: \"%s\"\n", str);

	return ((sign < 0) ? -result : result);
}

/* random number generator: uniform distribution from min to max inclusive */
static int64
getrand(TState *thread, int64 min, int64 max)
{
	/*
	 * Odd coding is so that min and max have approximately the same chance of
	 * being selected as do numbers between them.
	 *
	 * pg_erand48() is thread-safe and concurrent, which is why we use it
	 * rather than random(), which in glibc is non-reentrant, and therefore
	 * protected by a mutex, and therefore a bottleneck on machines with many
	 * CPUs.
	 */
	return min + (int64) ((max - min + 1) * pg_erand48(thread->random_state));
}

/*
 * random number generator: exponential distribution from min to max inclusive.
 * the parameter is so that the density of probability for the last cut-off max
 * value is exp(-parameter).
 */
static int64
getExponentialRand(TState *thread, int64 min, int64 max, double parameter)
{
	double		cut,
				uniform,
				rand;

	/* abort if wrong parameter, but must really be checked beforehand */
	Assert(parameter > 0.0);
	cut = exp(-parameter);
	/* erand in [0, 1), uniform in (0, 1] */
	uniform = 1.0 - pg_erand48(thread->random_state);

	/*
	 * inner expression in (cut, 1] (if parameter > 0), rand in [0, 1)
	 */
	Assert((1.0 - cut) != 0.0);
	rand = -log(cut + (1.0 - cut) * uniform) / parameter;
	/* return int64 random number within between min and max */
	return min + (int64) ((max - min + 1) * rand);
}

/* random number generator: gaussian distribution from min to max inclusive */
static int64
getGaussianRand(TState *thread, int64 min, int64 max, double parameter)
{
	double		stdev;
	double		rand;

	/* abort if parameter is too low, but must really be checked beforehand */
	Assert(parameter >= MIN_GAUSSIAN_PARAM);

	/*
	 * Get user specified random number from this loop, with -parameter <
	 * stdev <= parameter
	 *
	 * This loop is executed until the number is in the expected range.
	 *
	 * As the minimum parameter is 2.0, the probability of looping is low:
	 * sqrt(-2 ln(r)) <= 2 => r >= e^{-2} ~ 0.135, then when taking the
	 * average sinus multiplier as 2/pi, we have a 8.6% looping probability in
	 * the worst case. For a parameter value of 5.0, the looping probability
	 * is about e^{-5} * 2 / pi ~ 0.43%.
	 */
	do
	{
		/*
		 * pg_erand48 generates [0,1), but for the basic version of the
		 * Box-Muller transform the two uniformly distributed random numbers
		 * are expected in (0, 1] (see
		 * http://en.wikipedia.org/wiki/Box_muller)
		 */
		double		rand1 = 1.0 - pg_erand48(thread->random_state);
		double		rand2 = 1.0 - pg_erand48(thread->random_state);

		/* Box-Muller basic form transform */
		double		var_sqrt = sqrt(-2.0 * log(rand1));

		stdev = var_sqrt * sin(2.0 * M_PI * rand2);

		/*
		 * we may try with cos, but there may be a bias induced if the
		 * previous value fails the test. To be on the safe side, let us try
		 * over.
		 */
	}
	while (stdev < -parameter || stdev >= parameter);

	/* stdev is in [-parameter, parameter), normalization to [0,1) */
	rand = (stdev + parameter) / (parameter * 2.0);

	/* return int64 random number within between min and max */
	return min + (int64) ((max - min + 1) * rand);
}

/*
 * random number generator: generate a value, such that the series of values
 * will approximate a Poisson distribution centered on the given value.
 */
static int64
getPoissonRand(TState *thread, int64 center)
{
	/*
	 * Use inverse transform sampling to generate a value > 0, such that the
	 * expected (i.e. average) value is the given argument.
	 */
	double		uniform;

	/* erand in [0, 1), uniform in (0, 1] */
	uniform = 1.0 - pg_erand48(thread->random_state);

	return (int64) (-log(uniform) * ((double) center) + 0.5);
}

/*
 * Initialize the given SimpleStats struct to all zeroes
 */
static void
initSimpleStats(SimpleStats *ss)
{
	memset(ss, 0, sizeof(SimpleStats));
}

/*
 * Accumulate one value into a SimpleStats struct.
 */
static void
addToSimpleStats(SimpleStats *ss, double val)
{
	if (ss->count == 0 || val < ss->min)
		ss->min = val;
	if (ss->count == 0 || val > ss->max)
		ss->max = val;
	ss->count++;
	ss->sum += val;
	ss->sum2 += val * val;
}

/*
 * Merge two SimpleStats objects
 */
static void
mergeSimpleStats(SimpleStats *acc, SimpleStats *ss)
{
	if (acc->count == 0 || ss->min < acc->min)
		acc->min = ss->min;
	if (acc->count == 0 || ss->max > acc->max)
		acc->max = ss->max;
	acc->count += ss->count;
	acc->sum += ss->sum;
	acc->sum2 += ss->sum2;
}

/*
 * Initialize a StatsData struct to mostly zeroes, with its start time set to
 * the given value.
 */
static void
initStats(StatsData *sd, double start_time)
{
	sd->start_time = start_time;
	sd->cnt = 0;
	sd->skipped = 0;
	initSimpleStats(&sd->latency);
	initSimpleStats(&sd->lag);
}

/*
 * Accumulate one additional item into the given stats object.
 */
static void
accumStats(StatsData *stats, bool skipped, double lat, double lag)
{
	stats->cnt++;

	if (skipped)
	{
		/* no latency to record on skipped transactions */
		stats->skipped++;
	}
	else
	{
		addToSimpleStats(&stats->latency, lat);

		/* and possibly the same for schedule lag */
		if (throttle_delay)
			addToSimpleStats(&stats->lag, lag);
	}
}

/* call PQexec() and exit() on failure */
static void
executeStatement(PGconn *con, const char *sql)
{
	PGresult   *res;

	res = PQexec(con, sql);
	if (PQresultStatus(res) != PGRES_COMMAND_OK)
	{
		fprintf(stderr, "%s", PQerrorMessage(con));
		exit(1);
	}
	PQclear(res);
}

/* call PQexec() and complain, but without exiting, on failure */
static void
tryExecuteStatement(PGconn *con, const char *sql)
{
	PGresult   *res;

	res = PQexec(con, sql);
	if (PQresultStatus(res) != PGRES_COMMAND_OK)
	{
		fprintf(stderr, "%s", PQerrorMessage(con));
		fprintf(stderr, "(ignoring this error and continuing anyway)\n");
	}
	PQclear(res);
}

/* set up a connection to the backend */
static PGconn *
doConnect(void)
{
	PGconn	   *conn;
	static char *password = NULL;
	bool		new_pass;

	/*
	 * Start the connection.  Loop until we have a password if requested by
	 * backend.
	 */
	do
	{
#define PARAMS_ARRAY_SIZE	7

		const char *keywords[PARAMS_ARRAY_SIZE];
		const char *values[PARAMS_ARRAY_SIZE];

		keywords[0] = "host";
		values[0] = pghost;
		keywords[1] = "port";
		values[1] = pgport;
		keywords[2] = "user";
		values[2] = login;
		keywords[3] = "password";
		values[3] = password;
		keywords[4] = "dbname";
		values[4] = dbName;
		keywords[5] = "fallback_application_name";
		values[5] = progname;
		keywords[6] = NULL;
		values[6] = NULL;

		new_pass = false;

		conn = PQconnectdbParams(keywords, values, true);

		if (!conn)
		{
			fprintf(stderr, "connection to database \"%s\" failed\n",
					dbName);
			return NULL;
		}

		if (PQstatus(conn) == CONNECTION_BAD &&
			PQconnectionNeedsPassword(conn) &&
			password == NULL)
		{
			PQfinish(conn);
			password = simple_prompt("Password: ", 100, false);
			new_pass = true;
		}
	} while (new_pass);

	/* check to see that the backend connection was successfully made */
	if (PQstatus(conn) == CONNECTION_BAD)
	{
		fprintf(stderr, "connection to database \"%s\" failed:\n%s",
				dbName, PQerrorMessage(conn));
		PQfinish(conn);
		return NULL;
	}

	return conn;
}

/* throw away response from backend */
static void
discard_response(CState *state)
{
	PGresult   *res;

	do
	{
		res = PQgetResult(state->con);
		if (res)
			PQclear(res);
	} while (res);
}

/* qsort comparator for Variable array */
static int
compareVariableNames(const void *v1, const void *v2)
{
	return strcmp(((const Variable *) v1)->name,
				  ((const Variable *) v2)->name);
}

/* Locate a variable by name; returns NULL if unknown */
static Variable *
lookupVariable(CState *st, char *name)
{
	Variable	key;

	/* On some versions of Solaris, bsearch of zero items dumps core */
	if (st->nvariables <= 0)
		return NULL;

	/* Sort if we have to */
	if (!st->vars_sorted)
	{
		qsort((void *) st->variables, st->nvariables, sizeof(Variable),
			  compareVariableNames);
		st->vars_sorted = true;
	}

	/* Now we can search */
	key.name = name;
	return (Variable *) bsearch((void *) &key,
								(void *) st->variables,
								st->nvariables,
								sizeof(Variable),
								compareVariableNames);
}

/* Get the value of a variable, in string form; returns NULL if unknown */
static char *
getVariable(CState *st, char *name)
{
	Variable   *var;
	char		stringform[64];

	var = lookupVariable(st, name);
	if (var == NULL)
		return NULL;			/* not found */

	if (var->value)
		return var->value;		/* we have it in string form */

	/* We need to produce a string equivalent of the numeric value */
	Assert(var->is_numeric);
	if (var->num_value.type == PGBT_INT)
		snprintf(stringform, sizeof(stringform),
				 INT64_FORMAT, var->num_value.u.ival);
	else
	{
		Assert(var->num_value.type == PGBT_DOUBLE);
		snprintf(stringform, sizeof(stringform),
				 "%.*g", DBL_DIG, var->num_value.u.dval);
	}
	var->value = pg_strdup(stringform);
	return var->value;
}

/* Try to convert variable to numeric form; return false on failure */
static bool
makeVariableNumeric(Variable *var)
{
	if (var->is_numeric)
		return true;			/* no work */

	if (is_an_int(var->value))
	{
		setIntValue(&var->num_value, strtoint64(var->value));
		var->is_numeric = true;
	}
	else	/* type should be double */
	{
		double		dv;
		char		xs;

		if (sscanf(var->value, "%lf%c", &dv, &xs) != 1)
		{
			fprintf(stderr,
					"malformed variable \"%s\" value: \"%s\"\n",
					var->name, var->value);
			return false;
		}
		setDoubleValue(&var->num_value, dv);
		var->is_numeric = true;
	}
	return true;
}

/* check whether the name consists of alphabets, numerals and underscores. */
static bool
isLegalVariableName(const char *name)
{
	int			i;

	for (i = 0; name[i] != '\0'; i++)
	{
		if (!isalnum((unsigned char) name[i]) && name[i] != '_')
			return false;
	}

	return (i > 0);				/* must be non-empty */
}

/*
 * Lookup a variable by name, creating it if need be.
 * Caller is expected to assign a value to the variable.
 * Returns NULL on failure (bad name).
 */
static Variable *
lookupCreateVariable(CState *st, const char *context, char *name)
{
	Variable   *var;

	var = lookupVariable(st, name);
	if (var == NULL)
	{
		Variable   *newvars;

		/*
		 * Check for the name only when declaring a new variable to avoid
		 * overhead.
		 */
		if (!isLegalVariableName(name))
		{
			fprintf(stderr, "%s: invalid variable name: \"%s\"\n",
					context, name);
			return NULL;
		}

		/* Create variable at the end of the array */
		if (st->variables)
			newvars = (Variable *) pg_realloc(st->variables,
									(st->nvariables + 1) * sizeof(Variable));
		else
			newvars = (Variable *) pg_malloc(sizeof(Variable));

		st->variables = newvars;

		var = &newvars[st->nvariables];

		var->name = pg_strdup(name);
		var->value = NULL;
		/* caller is expected to initialize remaining fields */

		st->nvariables++;
		/* we don't re-sort the array till we have to */
		st->vars_sorted = false;
	}

	return var;
}

/* Assign a string value to a variable, creating it if need be */
/* Returns false on failure (bad name) */
static bool
putVariable(CState *st, const char *context, char *name, const char *value)
{
	Variable   *var;
	char	   *val;

	var = lookupCreateVariable(st, context, name);
	if (!var)
		return false;

	/* dup then free, in case value is pointing at this variable */
	val = pg_strdup(value);

	if (var->value)
		free(var->value);
	var->value = val;
	var->is_numeric = false;

	return true;
}

/* Assign a numeric value to a variable, creating it if need be */
/* Returns false on failure (bad name) */
static bool
putVariableNumber(CState *st, const char *context, char *name,
				  const PgBenchValue *value)
{
	Variable   *var;

	var = lookupCreateVariable(st, context, name);
	if (!var)
		return false;

	if (var->value)
		free(var->value);
	var->value = NULL;
	var->is_numeric = true;
	var->num_value = *value;

	return true;
}

/* Assign an integer value to a variable, creating it if need be */
/* Returns false on failure (bad name) */
static bool
putVariableInt(CState *st, const char *context, char *name, int64 value)
{
	PgBenchValue val;

	setIntValue(&val, value);
	return putVariableNumber(st, context, name, &val);
}

static char *
parseVariable(const char *sql, int *eaten)
{
	int			i = 0;
	char	   *name;

	do
	{
		i++;
	} while (isalnum((unsigned char) sql[i]) || sql[i] == '_');
	if (i == 1)
		return NULL;

	name = pg_malloc(i);
	memcpy(name, &sql[1], i - 1);
	name[i - 1] = '\0';

	*eaten = i;
	return name;
}

static char *
replaceVariable(char **sql, char *param, int len, char *value)
{
	int			valueln = strlen(value);

	if (valueln > len)
	{
		size_t		offset = param - *sql;

		*sql = pg_realloc(*sql, strlen(*sql) - len + valueln + 1);
		param = *sql + offset;
	}

	if (valueln != len)
		memmove(param + valueln, param + len, strlen(param + len) + 1);
	memcpy(param, value, valueln);

	return param + valueln;
}

static char *
assignVariables(CState *st, char *sql)
{
	char	   *p,
			   *name,
			   *val;

	p = sql;
	while ((p = strchr(p, ':')) != NULL)
	{
		int			eaten;

		name = parseVariable(p, &eaten);
		if (name == NULL)
		{
			while (*p == ':')
			{
				p++;
			}
			continue;
		}

		val = getVariable(st, name);
		free(name);
		if (val == NULL)
		{
			p++;
			continue;
		}

		p = replaceVariable(&sql, p, eaten, val);
	}

	return sql;
}

static void
getQueryParams(CState *st, const Command *command, const char **params)
{
	int			i;

	for (i = 0; i < command->argc - 1; i++)
		params[i] = getVariable(st, command->argv[i + 1]);
}

/* get a value as an int, tell if there is a problem */
static bool
coerceToInt(PgBenchValue *pval, int64 *ival)
{
	if (pval->type == PGBT_INT)
	{
		*ival = pval->u.ival;
		return true;
	}
	else
	{
		double		dval = pval->u.dval;

		Assert(pval->type == PGBT_DOUBLE);
		if (dval < PG_INT64_MIN || PG_INT64_MAX < dval)
		{
			fprintf(stderr, "double to int overflow for %f\n", dval);
			return false;
		}
		*ival = (int64) dval;
		return true;
	}
}

/* get a value as a double, or tell if there is a problem */
static bool
coerceToDouble(PgBenchValue *pval, double *dval)
{
	if (pval->type == PGBT_DOUBLE)
	{
		*dval = pval->u.dval;
		return true;
	}
	else
	{
		Assert(pval->type == PGBT_INT);
		*dval = (double) pval->u.ival;
		return true;
	}
}

/* assign an integer value */
static void
setIntValue(PgBenchValue *pv, int64 ival)
{
	pv->type = PGBT_INT;
	pv->u.ival = ival;
}

/* assign a double value */
static void
setDoubleValue(PgBenchValue *pv, double dval)
{
	pv->type = PGBT_DOUBLE;
	pv->u.dval = dval;
}

/* maximum number of function arguments */
#define MAX_FARGS 16

/*
 * Recursive evaluation of functions
 */
static bool
evalFunc(TState *thread, CState *st,
		 PgBenchFunction func, PgBenchExprLink *args, PgBenchValue *retval)
{
	/* evaluate all function arguments */
	int			nargs = 0;
	PgBenchValue vargs[MAX_FARGS];
	PgBenchExprLink *l = args;

	for (nargs = 0; nargs < MAX_FARGS && l != NULL; nargs++, l = l->next)
		if (!evaluateExpr(thread, st, l->expr, &vargs[nargs]))
			return false;

	if (l != NULL)
	{
		fprintf(stderr,
				"too many function arguments, maximum is %d\n", MAX_FARGS);
		return false;
	}

	/* then evaluate function */
	switch (func)
	{
			/* overloaded operators */
		case PGBENCH_ADD:
		case PGBENCH_SUB:
		case PGBENCH_MUL:
		case PGBENCH_DIV:
		case PGBENCH_MOD:
			{
				PgBenchValue *lval = &vargs[0],
						   *rval = &vargs[1];

				Assert(nargs == 2);

				/* overloaded type management, double if some double */
				if ((lval->type == PGBT_DOUBLE ||
					 rval->type == PGBT_DOUBLE) && func != PGBENCH_MOD)
				{
					double		ld,
								rd;

					if (!coerceToDouble(lval, &ld) ||
						!coerceToDouble(rval, &rd))
						return false;

					switch (func)
					{
						case PGBENCH_ADD:
							setDoubleValue(retval, ld + rd);
							return true;

						case PGBENCH_SUB:
							setDoubleValue(retval, ld - rd);
							return true;

						case PGBENCH_MUL:
							setDoubleValue(retval, ld * rd);
							return true;

						case PGBENCH_DIV:
							setDoubleValue(retval, ld / rd);
							return true;

						default:
							/* cannot get here */
							Assert(0);
					}
				}
				else	/* we have integer operands, or % */
				{
					int64		li,
								ri;

					if (!coerceToInt(lval, &li) ||
						!coerceToInt(rval, &ri))
						return false;

					switch (func)
					{
						case PGBENCH_ADD:
							setIntValue(retval, li + ri);
							return true;

						case PGBENCH_SUB:
							setIntValue(retval, li - ri);
							return true;

						case PGBENCH_MUL:
							setIntValue(retval, li * ri);
							return true;

						case PGBENCH_DIV:
						case PGBENCH_MOD:
							if (ri == 0)
							{
								fprintf(stderr, "division by zero\n");
								return false;
							}
							/* special handling of -1 divisor */
							if (ri == -1)
							{
								if (func == PGBENCH_DIV)
								{
									/* overflow check (needed for INT64_MIN) */
									if (li == PG_INT64_MIN)
									{
										fprintf(stderr, "bigint out of range\n");
										return false;
									}
									else
										setIntValue(retval, -li);
								}
								else
									setIntValue(retval, 0);
								return true;
							}
							/* else divisor is not -1 */
							if (func == PGBENCH_DIV)
								setIntValue(retval, li / ri);
							else	/* func == PGBENCH_MOD */
								setIntValue(retval, li % ri);

							return true;

						default:
							/* cannot get here */
							Assert(0);
					}
				}
			}

			/* no arguments */
		case PGBENCH_PI:
			setDoubleValue(retval, M_PI);
			return true;

			/* 1 overloaded argument */
		case PGBENCH_ABS:
			{
				PgBenchValue *varg = &vargs[0];

				Assert(nargs == 1);

				if (varg->type == PGBT_INT)
				{
					int64		i = varg->u.ival;

					setIntValue(retval, i < 0 ? -i : i);
				}
				else
				{
					double		d = varg->u.dval;

					Assert(varg->type == PGBT_DOUBLE);
					setDoubleValue(retval, d < 0.0 ? -d : d);
				}

				return true;
			}

		case PGBENCH_DEBUG:
			{
				PgBenchValue *varg = &vargs[0];

				Assert(nargs == 1);

				fprintf(stderr, "debug(script=%d,command=%d): ",
						st->use_file, st->state + 1);

				if (varg->type == PGBT_INT)
					fprintf(stderr, "int " INT64_FORMAT "\n", varg->u.ival);
				else
				{
					Assert(varg->type == PGBT_DOUBLE);
					fprintf(stderr, "double %.*g\n", DBL_DIG, varg->u.dval);
				}

				*retval = *varg;

				return true;
			}

			/* 1 double argument */
		case PGBENCH_DOUBLE:
		case PGBENCH_SQRT:
			{
				double		dval;

				Assert(nargs == 1);

				if (!coerceToDouble(&vargs[0], &dval))
					return false;

				if (func == PGBENCH_SQRT)
					dval = sqrt(dval);

				setDoubleValue(retval, dval);
				return true;
			}

			/* 1 int argument */
		case PGBENCH_INT:
			{
				int64		ival;

				Assert(nargs == 1);

				if (!coerceToInt(&vargs[0], &ival))
					return false;

				setIntValue(retval, ival);
				return true;
			}

			/* variable number of arguments */
		case PGBENCH_LEAST:
		case PGBENCH_GREATEST:
			{
				bool		havedouble;
				int			i;

				Assert(nargs >= 1);

				/* need double result if any input is double */
				havedouble = false;
				for (i = 0; i < nargs; i++)
				{
					if (vargs[i].type == PGBT_DOUBLE)
					{
						havedouble = true;
						break;
					}
				}
				if (havedouble)
				{
					double		extremum;

					if (!coerceToDouble(&vargs[0], &extremum))
						return false;
					for (i = 1; i < nargs; i++)
					{
						double		dval;

						if (!coerceToDouble(&vargs[i], &dval))
							return false;
						if (func == PGBENCH_LEAST)
							extremum = Min(extremum, dval);
						else
							extremum = Max(extremum, dval);
					}
					setDoubleValue(retval, extremum);
				}
				else
				{
					int64		extremum;

					if (!coerceToInt(&vargs[0], &extremum))
						return false;
					for (i = 1; i < nargs; i++)
					{
						int64		ival;

						if (!coerceToInt(&vargs[i], &ival))
							return false;
						if (func == PGBENCH_LEAST)
							extremum = Min(extremum, ival);
						else
							extremum = Max(extremum, ival);
					}
					setIntValue(retval, extremum);
				}
				return true;
			}

			/* random functions */
		case PGBENCH_RANDOM:
		case PGBENCH_RANDOM_EXPONENTIAL:
		case PGBENCH_RANDOM_GAUSSIAN:
			{
				int64		imin,
							imax;

				Assert(nargs >= 2);

				if (!coerceToInt(&vargs[0], &imin) ||
					!coerceToInt(&vargs[1], &imax))
					return false;

				/* check random range */
				if (imin > imax)
				{
					fprintf(stderr, "empty range given to random\n");
					return false;
				}
				else if (imax - imin < 0 || (imax - imin) + 1 < 0)
				{
					/* prevent int overflows in random functions */
					fprintf(stderr, "random range is too large\n");
					return false;
				}

				if (func == PGBENCH_RANDOM)
				{
					Assert(nargs == 2);
					setIntValue(retval, getrand(thread, imin, imax));
				}
				else	/* gaussian & exponential */
				{
					double		param;

					Assert(nargs == 3);

					if (!coerceToDouble(&vargs[2], &param))
						return false;

					if (func == PGBENCH_RANDOM_GAUSSIAN)
					{
						if (param < MIN_GAUSSIAN_PARAM)
						{
							fprintf(stderr,
									"gaussian parameter must be at least %f "
									"(not %f)\n", MIN_GAUSSIAN_PARAM, param);
							return false;
						}

						setIntValue(retval,
								 getGaussianRand(thread, imin, imax, param));
					}
					else	/* exponential */
					{
						if (param <= 0.0)
						{
							fprintf(stderr,
							"exponential parameter must be greater than zero"
									" (got %f)\n", param);
							return false;
						}

						setIntValue(retval,
							  getExponentialRand(thread, imin, imax, param));
					}
				}

				return true;
			}

		default:
			/* cannot get here */
			Assert(0);
			/* dead code to avoid a compiler warning */
			return false;
	}
}

/*
 * Recursive evaluation of an expression in a pgbench script
 * using the current state of variables.
 * Returns whether the evaluation was ok,
 * the value itself is returned through the retval pointer.
 */
static bool
evaluateExpr(TState *thread, CState *st, PgBenchExpr *expr, PgBenchValue *retval)
{
	switch (expr->etype)
	{
		case ENODE_CONSTANT:
			{
				*retval = expr->u.constant;
				return true;
			}

		case ENODE_VARIABLE:
			{
				Variable   *var;

				if ((var = lookupVariable(st, expr->u.variable.varname)) == NULL)
				{
					fprintf(stderr, "undefined variable \"%s\"\n",
							expr->u.variable.varname);
					return false;
				}

				if (!makeVariableNumeric(var))
					return false;

				*retval = var->num_value;
				return true;
			}

		case ENODE_FUNCTION:
			return evalFunc(thread, st,
							expr->u.function.function,
							expr->u.function.args,
							retval);

		default:
			/* internal error which should never occur */
			fprintf(stderr, "unexpected enode type in evaluation: %d\n",
					expr->etype);
			exit(1);
	}
}

/*
 * Run a shell command. The result is assigned to the variable if not NULL.
 * Return true if succeeded, or false on error.
 */
static bool
runShellCommand(CState *st, char *variable, char **argv, int argc)
{
	char		command[SHELL_COMMAND_SIZE];
	int			i,
				len = 0;
	FILE	   *fp;
	char		res[64];
	char	   *endptr;
	int			retval;

	/*----------
	 * Join arguments with whitespace separators. Arguments starting with
	 * exactly one colon are treated as variables:
	 *	name - append a string "name"
	 *	:var - append a variable named 'var'
	 *	::name - append a string ":name"
	 *----------
	 */
	for (i = 0; i < argc; i++)
	{
		char	   *arg;
		int			arglen;

		if (argv[i][0] != ':')
		{
			arg = argv[i];		/* a string literal */
		}
		else if (argv[i][1] == ':')
		{
			arg = argv[i] + 1;	/* a string literal starting with colons */
		}
		else if ((arg = getVariable(st, argv[i] + 1)) == NULL)
		{
			fprintf(stderr, "%s: undefined variable \"%s\"\n",
					argv[0], argv[i]);
			return false;
		}

		arglen = strlen(arg);
		if (len + arglen + (i > 0 ? 1 : 0) >= SHELL_COMMAND_SIZE - 1)
		{
			fprintf(stderr, "%s: shell command is too long\n", argv[0]);
			return false;
		}

		if (i > 0)
			command[len++] = ' ';
		memcpy(command + len, arg, arglen);
		len += arglen;
	}

	command[len] = '\0';

	/* Fast path for non-assignment case */
	if (variable == NULL)
	{
		if (system(command))
		{
			if (!timer_exceeded)
				fprintf(stderr, "%s: could not launch shell command\n", argv[0]);
			return false;
		}
		return true;
	}

	/* Execute the command with pipe and read the standard output. */
	if ((fp = popen(command, "r")) == NULL)
	{
		fprintf(stderr, "%s: could not launch shell command\n", argv[0]);
		return false;
	}
	if (fgets(res, sizeof(res), fp) == NULL)
	{
		if (!timer_exceeded)
			fprintf(stderr, "%s: could not read result of shell command\n", argv[0]);
		(void) pclose(fp);
		return false;
	}
	if (pclose(fp) < 0)
	{
		fprintf(stderr, "%s: could not close shell command\n", argv[0]);
		return false;
	}

	/* Check whether the result is an integer and assign it to the variable */
	retval = (int) strtol(res, &endptr, 10);
	while (*endptr != '\0' && isspace((unsigned char) *endptr))
		endptr++;
	if (*res == '\0' || *endptr != '\0')
	{
		fprintf(stderr, "%s: shell command must return an integer (not \"%s\")\n",
				argv[0], res);
		return false;
	}
	if (!putVariableInt(st, "setshell", variable, retval))
		return false;

#ifdef DEBUG
	printf("shell parameter name: \"%s\", value: \"%s\"\n", argv[1], res);
#endif
	return true;
}

#define MAX_PREPARE_NAME		32
static void
preparedStatementName(char *buffer, int file, int state)
{
	sprintf(buffer, "P%d_%d", file, state);
}

static bool
clientDone(CState *st)
{
	if (st->con != NULL)
	{
		PQfinish(st->con);
		st->con = NULL;
	}
	return false;				/* always false */
}

/* return a script number with a weighted choice. */
static int
chooseScript(TState *thread)
{
	int			i = 0;
	int64		w;

	if (num_scripts == 1)
		return 0;

	w = getrand(thread, 0, total_weight - 1);
	do
	{
		w -= sql_script[i++].weight;
	} while (w >= 0);

	return i - 1;
}

/* return false iff client should be disconnected */
static bool
doCustom(TState *thread, CState *st, StatsData *agg)
{
	PGresult   *res;
	Command   **commands;
	bool		trans_needs_throttle = false;
	instr_time	now;

	/*
	 * gettimeofday() isn't free, so we get the current timestamp lazily the
	 * first time it's needed, and reuse the same value throughout this
	 * function after that. This also ensures that e.g. the calculated latency
	 * reported in the log file and in the totals are the same. Zero means
	 * "not set yet". Reset "now" when we step to the next command with "goto
	 * top", though.
	 */
top:
	INSTR_TIME_SET_ZERO(now);

	commands = sql_script[st->use_file].commands;

	/*
	 * Handle throttling once per transaction by sleeping.  It is simpler to
	 * do this here rather than at the end, because so much complicated logic
	 * happens below when statements finish.
	 */
	if (throttle_delay && !st->is_throttled)
	{
		/*
		 * Generate a delay such that the series of delays will approximate a
		 * Poisson distribution centered on the throttle_delay time.
		 *
		 * If transactions are too slow or a given wait is shorter than a
		 * transaction, the next transaction will start right away.
		 */
		int64		wait = getPoissonRand(thread, throttle_delay);

		thread->throttle_trigger += wait;
		st->txn_scheduled = thread->throttle_trigger;

		/* stop client if next transaction is beyond pgbench end of execution */
		if (duration > 0 && st->txn_scheduled > end_time)
			return clientDone(st);

		/*
		 * If this --latency-limit is used, and this slot is already late so
		 * that the transaction will miss the latency limit even if it
		 * completed immediately, we skip this time slot and iterate till the
		 * next slot that isn't late yet.
		 */
		if (latency_limit)
		{
			int64		now_us;

			if (INSTR_TIME_IS_ZERO(now))
				INSTR_TIME_SET_CURRENT(now);
			now_us = INSTR_TIME_GET_MICROSEC(now);
			while (thread->throttle_trigger < now_us - latency_limit)
			{
				processXactStats(thread, st, &now, true, agg);
				/* next rendez-vous */
				wait = getPoissonRand(thread, throttle_delay);
				thread->throttle_trigger += wait;
				st->txn_scheduled = thread->throttle_trigger;
			}
		}

		st->sleeping = true;
		st->throttling = true;
		st->is_throttled = true;
		if (debug)
			fprintf(stderr, "client %d throttling " INT64_FORMAT " us\n",
					st->id, wait);
	}

	if (st->sleeping)
	{							/* are we sleeping? */
		if (INSTR_TIME_IS_ZERO(now))
			INSTR_TIME_SET_CURRENT(now);
		if (INSTR_TIME_GET_MICROSEC(now) < st->txn_scheduled)
			return true;		/* Still sleeping, nothing to do here */
		/* Else done sleeping, go ahead with next command */
		st->sleeping = false;
		st->throttling = false;
	}

	if (st->listen)
	{							/* are we receiver? */
		if (commands[st->state]->type == SQL_COMMAND)
		{
			if (debug)
				fprintf(stderr, "client %d receiving\n", st->id);
			if (!PQconsumeInput(st->con))
			{					/* there's something wrong */
				fprintf(stderr, "client %d aborted in state %d; perhaps the backend died while processing\n", st->id, st->state);
				return clientDone(st);
			}
			if (PQisBusy(st->con))
				return true;	/* don't have the whole result yet */
		}

		/*
		 * command finished: accumulate per-command execution times in
		 * thread-local data structure, if per-command latencies are requested
		 */
		if (is_latencies)
		{
			if (INSTR_TIME_IS_ZERO(now))
				INSTR_TIME_SET_CURRENT(now);

			/* XXX could use a mutex here, but we choose not to */
			addToSimpleStats(&commands[st->state]->stats,
							 INSTR_TIME_GET_DOUBLE(now) -
							 INSTR_TIME_GET_DOUBLE(st->stmt_begin));
		}

		/* transaction finished: calculate latency and log the transaction */
		if (commands[st->state + 1] == NULL)
		{
			if (progress || throttle_delay || latency_limit ||
				per_script_stats || use_log)
				processXactStats(thread, st, &now, false, agg);
			else
				thread->stats.cnt++;
		}

		if (commands[st->state]->type == SQL_COMMAND)
		{
			/*
			 * Read and discard the query result; note this is not included in
			 * the statement latency numbers.
			 */
			res = PQgetResult(st->con);
			switch (PQresultStatus(res))
			{
				case PGRES_COMMAND_OK:
				case PGRES_TUPLES_OK:
					break;		/* OK */
				default:
					fprintf(stderr, "client %d aborted in state %d: %s",
							st->id, st->state, PQerrorMessage(st->con));
					PQclear(res);
					return clientDone(st);
			}
			PQclear(res);
			discard_response(st);
		}

		if (commands[st->state + 1] == NULL)
		{
			if (is_connect)
			{
				PQfinish(st->con);
				st->con = NULL;
			}

			++st->cnt;
			if ((st->cnt >= nxacts && duration <= 0) || timer_exceeded)
				return clientDone(st);	/* exit success */
		}

		/* increment state counter */
		st->state++;
		if (commands[st->state] == NULL)
		{
			st->state = 0;
			st->use_file = chooseScript(thread);
			commands = sql_script[st->use_file].commands;
			if (debug)
				fprintf(stderr, "client %d executing script \"%s\"\n", st->id,
						sql_script[st->use_file].desc);
			st->is_throttled = false;

			/*
			 * No transaction is underway anymore, which means there is
			 * nothing to listen to right now.  When throttling rate limits
			 * are active, a sleep will happen next, as the next transaction
			 * starts.  And then in any case the next SQL command will set
			 * listen back to true.
			 */
			st->listen = false;
			trans_needs_throttle = (throttle_delay > 0);
		}
	}

	if (st->con == NULL)
	{
		instr_time	start,
					end;

		INSTR_TIME_SET_CURRENT(start);
		if ((st->con = doConnect()) == NULL)
		{
			fprintf(stderr, "client %d aborted while establishing connection\n",
					st->id);
			return clientDone(st);
		}
		INSTR_TIME_SET_CURRENT(end);
		INSTR_TIME_ACCUM_DIFF(thread->conn_time, end, start);

		/* Reset session-local state */
		st->listen = false;
		st->sleeping = false;
		st->throttling = false;
		st->is_throttled = false;
		memset(st->prepared, 0, sizeof(st->prepared));
	}

	/*
	 * This ensures that a throttling delay is inserted before proceeding with
	 * sql commands, after the first transaction. The first transaction
	 * throttling is performed when first entering doCustom.
	 */
	if (trans_needs_throttle)
	{
		trans_needs_throttle = false;
		goto top;
	}

	/* Record transaction start time under logging, progress or throttling */
	if ((use_log || progress || throttle_delay || latency_limit ||
		 per_script_stats) && st->state == 0)
	{
		INSTR_TIME_SET_CURRENT(st->txn_begin);

		/*
		 * When not throttling, this is also the transaction's scheduled start
		 * time.
		 */
		if (!throttle_delay)
			st->txn_scheduled = INSTR_TIME_GET_MICROSEC(st->txn_begin);
	}

	/* Record statement start time if per-command latencies are requested */
	if (is_latencies)
		INSTR_TIME_SET_CURRENT(st->stmt_begin);

	if (commands[st->state]->type == SQL_COMMAND)
	{
		const Command *command = commands[st->state];
		int			r;

		if (querymode == QUERY_SIMPLE)
		{
			char	   *sql;

			sql = pg_strdup(command->argv[0]);
			sql = assignVariables(st, sql);

			if (debug)
				fprintf(stderr, "client %d sending %s\n", st->id, sql);
			r = PQsendQuery(st->con, sql);
			free(sql);
		}
		else if (querymode == QUERY_EXTENDED)
		{
			const char *sql = command->argv[0];
			const char *params[MAX_ARGS];

			getQueryParams(st, command, params);

			if (debug)
				fprintf(stderr, "client %d sending %s\n", st->id, sql);
			r = PQsendQueryParams(st->con, sql, command->argc - 1,
								  NULL, params, NULL, NULL, 0);
		}
		else if (querymode == QUERY_PREPARED)
		{
			char		name[MAX_PREPARE_NAME];
			const char *params[MAX_ARGS];

			if (!st->prepared[st->use_file])
			{
				int			j;

				for (j = 0; commands[j] != NULL; j++)
				{
					PGresult   *res;
					char		name[MAX_PREPARE_NAME];

					if (commands[j]->type != SQL_COMMAND)
						continue;
					preparedStatementName(name, st->use_file, j);
					res = PQprepare(st->con, name,
						  commands[j]->argv[0], commands[j]->argc - 1, NULL);
					if (PQresultStatus(res) != PGRES_COMMAND_OK)
						fprintf(stderr, "%s", PQerrorMessage(st->con));
					PQclear(res);
				}
				st->prepared[st->use_file] = true;
			}

			getQueryParams(st, command, params);
			preparedStatementName(name, st->use_file, st->state);

			if (debug)
				fprintf(stderr, "client %d sending %s\n", st->id, name);
			r = PQsendQueryPrepared(st->con, name, command->argc - 1,
									params, NULL, NULL, 0);
		}
		else	/* unknown sql mode */
			r = 0;

		if (r == 0)
		{
			if (debug)
				fprintf(stderr, "client %d could not send %s\n",
						st->id, command->argv[0]);
			st->ecnt++;
		}
		else
			st->listen = true;	/* flags that should be listened */
	}
	else if (commands[st->state]->type == META_COMMAND)
	{
		int			argc = commands[st->state]->argc,
					i;
		char	  **argv = commands[st->state]->argv;

		if (debug)
		{
			fprintf(stderr, "client %d executing \\%s", st->id, argv[0]);
			for (i = 1; i < argc; i++)
				fprintf(stderr, " %s", argv[i]);
			fprintf(stderr, "\n");
		}

		if (pg_strcasecmp(argv[0], "set") == 0)
		{
			PgBenchExpr *expr = commands[st->state]->expr;
			PgBenchValue result;

			if (!evaluateExpr(thread, st, expr, &result))
			{
				st->ecnt++;
				return true;
			}

			if (!putVariableNumber(st, argv[0], argv[1], &result))
			{
				st->ecnt++;
				return true;
			}

			st->listen = true;
		}
		else if (pg_strcasecmp(argv[0], "sleep") == 0)
		{
			char	   *var;
			int			usec;
			instr_time	now;

			if (*argv[1] == ':')
			{
				if ((var = getVariable(st, argv[1] + 1)) == NULL)
				{
					fprintf(stderr, "%s: undefined variable \"%s\"\n",
							argv[0], argv[1]);
					st->ecnt++;
					return true;
				}
				usec = atoi(var);
			}
			else
				usec = atoi(argv[1]);

			if (argc > 2)
			{
				if (pg_strcasecmp(argv[2], "ms") == 0)
					usec *= 1000;
				else if (pg_strcasecmp(argv[2], "s") == 0)
					usec *= 1000000;
			}
			else
				usec *= 1000000;

			INSTR_TIME_SET_CURRENT(now);
			st->txn_scheduled = INSTR_TIME_GET_MICROSEC(now) + usec;
			st->sleeping = true;

			st->listen = true;
		}
		else if (pg_strcasecmp(argv[0], "setshell") == 0)
		{
			bool		ret = runShellCommand(st, argv[1], argv + 2, argc - 2);

			if (timer_exceeded) /* timeout */
				return clientDone(st);
			else if (!ret)		/* on error */
			{
				st->ecnt++;
				return true;
			}
			else	/* succeeded */
				st->listen = true;
		}
		else if (pg_strcasecmp(argv[0], "shell") == 0)
		{
			bool		ret = runShellCommand(st, NULL, argv + 1, argc - 1);

			if (timer_exceeded) /* timeout */
				return clientDone(st);
			else if (!ret)		/* on error */
			{
				st->ecnt++;
				return true;
			}
			else	/* succeeded */
				st->listen = true;
		}

		/* after a meta command, immediately proceed with next command */
		goto top;
	}

	return true;
}

/*
 * print log entry after completing one transaction.
 */
static void
doLog(TState *thread, CState *st, instr_time *now,
	  StatsData *agg, bool skipped, double latency, double lag)
{
	FILE	   *logfile = thread->logfile;

	Assert(use_log);

	/*
	 * Skip the log entry if sampling is enabled and this row doesn't belong
	 * to the random sample.
	 */
	if (sample_rate != 0.0 &&
		pg_erand48(thread->random_state) > sample_rate)
		return;

	/* should we aggregate the results or not? */
	if (agg_interval > 0)
	{
		/*
		 * Loop until we reach the interval of the current transaction, and
		 * print all the empty intervals in between (this may happen with very
		 * low tps, e.g. --rate=0.1).
		 */
		while (agg->start_time + agg_interval < INSTR_TIME_GET_DOUBLE(*now))
		{
			/* print aggregated report to logfile */
			fprintf(logfile, "%ld " INT64_FORMAT " %.0f %.0f %.0f %.0f",
					agg->start_time,
					agg->cnt,
					agg->latency.sum,
					agg->latency.sum2,
					agg->latency.min,
					agg->latency.max);
			if (throttle_delay)
			{
				fprintf(logfile, " %.0f %.0f %.0f %.0f",
						agg->lag.sum,
						agg->lag.sum2,
						agg->lag.min,
						agg->lag.max);
				if (latency_limit)
					fprintf(logfile, " " INT64_FORMAT, agg->skipped);
			}
			fputc('\n', logfile);

			/* reset data and move to next interval */
			initStats(agg, agg->start_time + agg_interval);
		}

		/* accumulate the current transaction */
		accumStats(agg, skipped, latency, lag);
	}
	else
	{
		/* no, print raw transactions */
#ifndef WIN32

		/* This is more than we really ought to know about instr_time */
		if (skipped)
			fprintf(logfile, "%d " INT64_FORMAT " skipped %d %ld %ld",
					st->id, st->cnt, st->use_file,
					(long) now->tv_sec, (long) now->tv_usec);
		else
			fprintf(logfile, "%d " INT64_FORMAT " %.0f %d %ld %ld",
					st->id, st->cnt, latency, st->use_file,
					(long) now->tv_sec, (long) now->tv_usec);
#else

		/* On Windows, instr_time doesn't provide a timestamp anyway */
		if (skipped)
			fprintf(logfile, "%d " INT64_FORMAT " skipped %d 0 0",
					st->id, st->cnt, st->use_file);
		else
			fprintf(logfile, "%d " INT64_FORMAT " %.0f %d 0 0",
					st->id, st->cnt, latency, st->use_file);
#endif
		if (throttle_delay)
			fprintf(logfile, " %.0f", lag);
		fputc('\n', logfile);
	}
}

/*
 * Accumulate and report statistics at end of a transaction.
 *
 * (This is also called when a transaction is late and thus skipped.)
 */
static void
processXactStats(TState *thread, CState *st, instr_time *now,
				 bool skipped, StatsData *agg)
{
	double		latency = 0.0,
				lag = 0.0;

	if ((!skipped || agg_interval) && INSTR_TIME_IS_ZERO(*now))
		INSTR_TIME_SET_CURRENT(*now);

	if (!skipped)
	{
		/* compute latency & lag */
		latency = INSTR_TIME_GET_MICROSEC(*now) - st->txn_scheduled;
		lag = INSTR_TIME_GET_MICROSEC(st->txn_begin) - st->txn_scheduled;
	}

	if (progress || throttle_delay || latency_limit)
	{
		accumStats(&thread->stats, skipped, latency, lag);

		/* count transactions over the latency limit, if needed */
		if (latency_limit && latency > latency_limit)
			thread->latency_late++;
	}
	else
		thread->stats.cnt++;

	if (use_log)
		doLog(thread, st, now, agg, skipped, latency, lag);

	/* XXX could use a mutex here, but we choose not to */
	if (per_script_stats)
		accumStats(&sql_script[st->use_file].stats, skipped, latency, lag);
}


/* discard connections */
static void
disconnect_all(CState *state, int length)
{
	int			i;

	for (i = 0; i < length; i++)
	{
		if (state[i].con)
		{
			PQfinish(state[i].con);
			state[i].con = NULL;
		}
	}
}

/* create tables and setup data */
static void
init(bool is_no_vacuum)
{
/*
 * The scale factor at/beyond which 32-bit integers are insufficient for
 * storing TPC-B account IDs.
 *
 * Although the actual threshold is 21474, we use 20000 because it is easier to
 * document and remember, and isn't that far away from the real threshold.
 */
#define SCALE_32BIT_THRESHOLD 20000

	/*
	 * Note: TPC-B requires at least 100 bytes per row, and the "filler"
	 * fields in these table declarations were intended to comply with that.
	 * The pgbench_accounts table complies with that because the "filler"
	 * column is set to blank-padded empty string. But for all other tables
	 * the columns default to NULL and so don't actually take any space.  We
	 * could fix that by giving them non-null default values.  However, that
	 * would completely break comparability of pgbench results with prior
	 * versions. Since pgbench has never pretended to be fully TPC-B compliant
	 * anyway, we stick with the historical behavior.
	 */
	struct ddlinfo
	{
		const char *table;		/* table name */
		const char *smcols;		/* column decls if accountIDs are 32 bits */
		const char *bigcols;	/* column decls if accountIDs are 64 bits */
		int			declare_fillfactor;
	};
	static const struct ddlinfo DDLs[] = {
		{
			"pgbench_history",
			"tid int,bid int,aid    int,delta int,mtime timestamp,filler char(22)",
			"tid int,bid int,aid bigint,delta int,mtime timestamp,filler char(22)",
			0
		},
		{
			"pgbench_tellers",
			"tid int not null,bid int,tbalance int,filler char(84)",
			"tid int not null,bid int,tbalance int,filler char(84)",
			1
		},
		{
			"pgbench_accounts",
			"aid    int not null,bid int,abalance int,filler char(84)",
			"aid bigint not null,bid int,abalance int,filler char(84)",
			1
		},
		{
			"pgbench_branches",
			"bid int not null,bbalance int,filler char(88)",
			"bid int not null,bbalance int,filler char(88)",
			1
		}
	};
	static const char *const DDLINDEXes[] = {
		"alter table pgbench_branches add primary key (bid)",
		"alter table pgbench_tellers add primary key (tid)",
		"alter table pgbench_accounts add primary key (aid)"
	};
	static const char *const DDLKEYs[] = {
		"alter table pgbench_tellers add foreign key (bid) references pgbench_branches",
		"alter table pgbench_accounts add foreign key (bid) references pgbench_branches",
		"alter table pgbench_history add foreign key (bid) references pgbench_branches",
		"alter table pgbench_history add foreign key (tid) references pgbench_tellers",
		"alter table pgbench_history add foreign key (aid) references pgbench_accounts"
	};

	PGconn	   *con;
	PGresult   *res;
	char		sql[256];
	int			i;
	int64		k;

	/* used to track elapsed time and estimate of the remaining time */
	instr_time	start,
				diff;
	double		elapsed_sec,
				remaining_sec;
	int			log_interval = 1;

	if ((con = doConnect()) == NULL)
		exit(1);

	for (i = 0; i < lengthof(DDLs); i++)
	{
		char		opts[256];
		char		buffer[256];
		const struct ddlinfo *ddl = &DDLs[i];
		const char *cols;

		/* Remove old table, if it exists. */
		snprintf(buffer, sizeof(buffer), "drop table if exists %s", ddl->table);
		executeStatement(con, buffer);

		/* Construct new create table statement. */
		opts[0] = '\0';
		if (ddl->declare_fillfactor)
			snprintf(opts + strlen(opts), sizeof(opts) - strlen(opts),
					 " with (fillfactor=%d)", fillfactor);
		if (tablespace != NULL)
		{
			char	   *escape_tablespace;

			escape_tablespace = PQescapeIdentifier(con, tablespace,
												   strlen(tablespace));
			snprintf(opts + strlen(opts), sizeof(opts) - strlen(opts),
					 " tablespace %s", escape_tablespace);
			PQfreemem(escape_tablespace);
		}

		cols = (scale >= SCALE_32BIT_THRESHOLD) ? ddl->bigcols : ddl->smcols;

		snprintf(buffer, sizeof(buffer), "create%s table %s(%s)%s",
				 unlogged_tables ? " unlogged" : "",
				 ddl->table, cols, opts);

		executeStatement(con, buffer);
	}

	executeStatement(con, "begin");

	for (i = 0; i < nbranches * scale; i++)
	{
		/* "filler" column defaults to NULL */
		snprintf(sql, sizeof(sql),
				 "insert into pgbench_branches(bid,bbalance) values(%d,0)",
				 i + 1);
		executeStatement(con, sql);
	}

	for (i = 0; i < ntellers * scale; i++)
	{
		/* "filler" column defaults to NULL */
		snprintf(sql, sizeof(sql),
			"insert into pgbench_tellers(tid,bid,tbalance) values (%d,%d,0)",
				 i + 1, i / ntellers + 1);
		executeStatement(con, sql);
	}

	executeStatement(con, "commit");

	/*
	 * fill the pgbench_accounts table with some data
	 */
	fprintf(stderr, "creating tables...\n");

	executeStatement(con, "begin");
	executeStatement(con, "truncate pgbench_accounts");

	res = PQexec(con, "copy pgbench_accounts from stdin");
	if (PQresultStatus(res) != PGRES_COPY_IN)
	{
		fprintf(stderr, "%s", PQerrorMessage(con));
		exit(1);
	}
	PQclear(res);

	INSTR_TIME_SET_CURRENT(start);

	for (k = 0; k < (int64) naccounts * scale; k++)
	{
		int64		j = k + 1;

		/* "filler" column defaults to blank padded empty string */
		snprintf(sql, sizeof(sql),
				 INT64_FORMAT "\t" INT64_FORMAT "\t%d\t\n",
				 j, k / naccounts + 1, 0);
		if (PQputline(con, sql))
		{
			fprintf(stderr, "PQputline failed\n");
			exit(1);
		}

		/*
		 * If we want to stick with the original logging, print a message each
		 * 100k inserted rows.
		 */
		if ((!use_quiet) && (j % 100000 == 0))
		{
			INSTR_TIME_SET_CURRENT(diff);
			INSTR_TIME_SUBTRACT(diff, start);

			elapsed_sec = INSTR_TIME_GET_DOUBLE(diff);
			remaining_sec = ((double) scale * naccounts - j) * elapsed_sec / j;

			fprintf(stderr, INT64_FORMAT " of " INT64_FORMAT " tuples (%d%%) done (elapsed %.2f s, remaining %.2f s)\n",
					j, (int64) naccounts * scale,
					(int) (((int64) j * 100) / (naccounts * (int64) scale)),
					elapsed_sec, remaining_sec);
		}
		/* let's not call the timing for each row, but only each 100 rows */
		else if (use_quiet && (j % 100 == 0))
		{
			INSTR_TIME_SET_CURRENT(diff);
			INSTR_TIME_SUBTRACT(diff, start);

			elapsed_sec = INSTR_TIME_GET_DOUBLE(diff);
			remaining_sec = ((double) scale * naccounts - j) * elapsed_sec / j;

			/* have we reached the next interval (or end)? */
			if ((j == scale * naccounts) || (elapsed_sec >= log_interval * LOG_STEP_SECONDS))
			{
				fprintf(stderr, INT64_FORMAT " of " INT64_FORMAT " tuples (%d%%) done (elapsed %.2f s, remaining %.2f s)\n",
						j, (int64) naccounts * scale,
						(int) (((int64) j * 100) / (naccounts * (int64) scale)), elapsed_sec, remaining_sec);

				/* skip to the next interval */
				log_interval = (int) ceil(elapsed_sec / LOG_STEP_SECONDS);
			}
		}

	}
	if (PQputline(con, "\\.\n"))
	{
		fprintf(stderr, "very last PQputline failed\n");
		exit(1);
	}
	if (PQendcopy(con))
	{
		fprintf(stderr, "PQendcopy failed\n");
		exit(1);
	}
	executeStatement(con, "commit");

	/* vacuum */
	if (!is_no_vacuum)
	{
		fprintf(stderr, "vacuum...\n");
		executeStatement(con, "vacuum analyze pgbench_branches");
		executeStatement(con, "vacuum analyze pgbench_tellers");
		executeStatement(con, "vacuum analyze pgbench_accounts");
		executeStatement(con, "vacuum analyze pgbench_history");
	}

	/*
	 * create indexes
	 */
	fprintf(stderr, "set primary keys...\n");
	for (i = 0; i < lengthof(DDLINDEXes); i++)
	{
		char		buffer[256];

		strlcpy(buffer, DDLINDEXes[i], sizeof(buffer));

		if (index_tablespace != NULL)
		{
			char	   *escape_tablespace;

			escape_tablespace = PQescapeIdentifier(con, index_tablespace,
												   strlen(index_tablespace));
			snprintf(buffer + strlen(buffer), sizeof(buffer) - strlen(buffer),
					 " using index tablespace %s", escape_tablespace);
			PQfreemem(escape_tablespace);
		}

		executeStatement(con, buffer);
	}

	/*
	 * create foreign keys
	 */
	if (foreign_keys)
	{
		fprintf(stderr, "set foreign keys...\n");
		for (i = 0; i < lengthof(DDLKEYs); i++)
		{
			executeStatement(con, DDLKEYs[i]);
		}
	}

	fprintf(stderr, "done.\n");
	PQfinish(con);
}

/*
 * Parse the raw sql and replace :param to $n.
 */
static bool
parseQuery(Command *cmd, const char *raw_sql)
{
	char	   *sql,
			   *p;

	sql = pg_strdup(raw_sql);
	cmd->argc = 1;

	p = sql;
	while ((p = strchr(p, ':')) != NULL)
	{
		char		var[12];
		char	   *name;
		int			eaten;

		name = parseVariable(p, &eaten);
		if (name == NULL)
		{
			while (*p == ':')
			{
				p++;
			}
			continue;
		}

		if (cmd->argc >= MAX_ARGS)
		{
			fprintf(stderr, "statement has too many arguments (maximum is %d): %s\n", MAX_ARGS - 1, raw_sql);
			pg_free(name);
			return false;
		}

		sprintf(var, "$%d", cmd->argc);
		p = replaceVariable(&sql, p, eaten, var);

		cmd->argv[cmd->argc] = name;
		cmd->argc++;
	}

	cmd->argv[0] = sql;
	return true;
}

/*
 * Simple error-printing function, might be needed by lexer
 */
static void
pgbench_error(const char *fmt,...)
{
	va_list		ap;

	fflush(stdout);
	va_start(ap, fmt);
	vfprintf(stderr, _(fmt), ap);
	va_end(ap);
}

/*
 * syntax error while parsing a script (in practice, while parsing a
 * backslash command, because we don't detect syntax errors in SQL)
 *
 * source: source of script (filename or builtin-script ID)
 * lineno: line number within script (count from 1)
 * line: whole line of backslash command, if available
 * command: backslash command name, if available
 * msg: the actual error message
 * more: optional extra message
 * column: zero-based column number, or -1 if unknown
 */
void
syntax_error(const char *source, int lineno,
			 const char *line, const char *command,
			 const char *msg, const char *more, int column)
{
	fprintf(stderr, "%s:%d: %s", source, lineno, msg);
	if (more != NULL)
		fprintf(stderr, " (%s)", more);
	if (column >= 0 && line == NULL)
		fprintf(stderr, " at column %d", column + 1);
	if (command != NULL)
		fprintf(stderr, " in command \"%s\"", command);
	fprintf(stderr, "\n");
	if (line != NULL)
	{
		fprintf(stderr, "%s\n", line);
		if (column >= 0)
		{
			int			i;

			for (i = 0; i < column; i++)
				fprintf(stderr, " ");
			fprintf(stderr, "^ error found here\n");
		}
	}
	exit(1);
}

/*
 * Parse a SQL command; return a Command struct, or NULL if it's a comment
 *
 * On entry, psqlscan.l has collected the command into "buf", so we don't
 * really need to do much here except check for comment and set up a
 * Command struct.
 */
static Command *
process_sql_command(PQExpBuffer buf, const char *source)
{
	Command    *my_command;
	char	   *p;
	char	   *nlpos;

	/* Skip any leading whitespace, as well as "--" style comments */
	p = buf->data;
	for (;;)
	{
		if (isspace((unsigned char) *p))
			p++;
		else if (strncmp(p, "--", 2) == 0)
		{
			p = strchr(p, '\n');
			if (p == NULL)
				return NULL;
			p++;
		}
		else
			break;
	}

	/* If there's nothing but whitespace and comments, we're done */
	if (*p == '\0')
		return NULL;

	/* Allocate and initialize Command structure */
	my_command = (Command *) pg_malloc0(sizeof(Command));
	my_command->command_num = num_commands++;
	my_command->type = SQL_COMMAND;
	my_command->argc = 0;
	initSimpleStats(&my_command->stats);

	/*
	 * If SQL command is multi-line, we only want to save the first line as
	 * the "line" label.
	 */
	nlpos = strchr(p, '\n');
	if (nlpos)
	{
		my_command->line = pg_malloc(nlpos - p + 1);
		memcpy(my_command->line, p, nlpos - p);
		my_command->line[nlpos - p] = '\0';
	}
	else
		my_command->line = pg_strdup(p);

	switch (querymode)
	{
		case QUERY_SIMPLE:
			my_command->argv[0] = pg_strdup(p);
			my_command->argc++;
			break;
		case QUERY_EXTENDED:
		case QUERY_PREPARED:
			if (!parseQuery(my_command, p))
				exit(1);
			break;
		default:
			exit(1);
	}

	return my_command;
}

/*
 * Parse a backslash command; return a Command struct, or NULL if comment
 *
 * At call, we have scanned only the initial backslash.
 */
static Command *
process_backslash_command(PsqlScanState sstate, const char *source)
{
	Command    *my_command;
	PQExpBufferData word_buf;
	int			word_offset;
	int			offsets[MAX_ARGS];		/* offsets of argument words */
	int			start_offset,
				end_offset;
	int			lineno;
	int			j;

	initPQExpBuffer(&word_buf);

	/* Remember location of the backslash */
	start_offset = expr_scanner_offset(sstate) - 1;
	lineno = expr_scanner_get_lineno(sstate, start_offset);

	/* Collect first word of command */
	if (!expr_lex_one_word(sstate, &word_buf, &word_offset))
	{
		termPQExpBuffer(&word_buf);
		return NULL;
	}

	/* Allocate and initialize Command structure */
	my_command = (Command *) pg_malloc0(sizeof(Command));
	my_command->command_num = num_commands++;
	my_command->type = META_COMMAND;
	my_command->argc = 0;
	initSimpleStats(&my_command->stats);

	/* Save first word (command name) */
	j = 0;
	offsets[j] = word_offset;
	my_command->argv[j++] = pg_strdup(word_buf.data);
	my_command->argc++;

	if (pg_strcasecmp(my_command->argv[0], "set") == 0)
	{
		/* For \set, collect var name, then lex the expression. */
		yyscan_t	yyscanner;

		if (!expr_lex_one_word(sstate, &word_buf, &word_offset))
			syntax_error(source, lineno, my_command->line, my_command->argv[0],
						 "missing argument", NULL, -1);

		offsets[j] = word_offset;
		my_command->argv[j++] = pg_strdup(word_buf.data);
		my_command->argc++;

		yyscanner = expr_scanner_init(sstate, source, lineno, start_offset,
									  my_command->argv[0]);

		if (expr_yyparse(yyscanner) != 0)
		{
			/* dead code: exit done from syntax_error called by yyerror */
			exit(1);
		}

		my_command->expr = expr_parse_result;

		/* Get location of the ending newline */
		end_offset = expr_scanner_offset(sstate) - 1;

		/* Save line */
		my_command->line = expr_scanner_get_substring(sstate,
													  start_offset,
													  end_offset);

		expr_scanner_finish(yyscanner);

		termPQExpBuffer(&word_buf);

		return my_command;
	}

	/* For all other commands, collect remaining words. */
	while (expr_lex_one_word(sstate, &word_buf, &word_offset))
	{
		if (j >= MAX_ARGS)
			syntax_error(source, lineno, my_command->line, my_command->argv[0],
						 "too many arguments", NULL, -1);

		offsets[j] = word_offset;
		my_command->argv[j++] = pg_strdup(word_buf.data);
		my_command->argc++;
	}

	/* Get location of the ending newline */
	end_offset = expr_scanner_offset(sstate) - 1;

	/* Save line */
	my_command->line = expr_scanner_get_substring(sstate,
												  start_offset,
												  end_offset);

	if (pg_strcasecmp(my_command->argv[0], "sleep") == 0)
	{
		if (my_command->argc < 2)
			syntax_error(source, lineno, my_command->line, my_command->argv[0],
						 "missing argument", NULL, -1);

		if (my_command->argc > 3)
			syntax_error(source, lineno, my_command->line, my_command->argv[0],
						 "too many arguments", NULL,
						 offsets[3] - start_offset);

		/*
		 * Split argument into number and unit to allow "sleep 1ms" etc. We
		 * don't have to terminate the number argument with null because it
		 * will be parsed with atoi, which ignores trailing non-digit
		 * characters.
		 */
		if (my_command->argc == 2 && my_command->argv[1][0] != ':')
		{
			char	   *c = my_command->argv[1];

			while (isdigit((unsigned char) *c))
				c++;
			if (*c)
			{
				my_command->argv[2] = c;
				offsets[2] = offsets[1] + (c - my_command->argv[1]);
				my_command->argc = 3;
			}
		}

		if (my_command->argc == 3)
		{
			if (pg_strcasecmp(my_command->argv[2], "us") != 0 &&
				pg_strcasecmp(my_command->argv[2], "ms") != 0 &&
				pg_strcasecmp(my_command->argv[2], "s") != 0)
				syntax_error(source, lineno, my_command->line, my_command->argv[0],
							 "unrecognized time unit, must be us, ms or s",
							 my_command->argv[2], offsets[2] - start_offset);
		}
	}
	else if (pg_strcasecmp(my_command->argv[0], "setshell") == 0)
	{
		if (my_command->argc < 3)
			syntax_error(source, lineno, my_command->line, my_command->argv[0],
						 "missing argument", NULL, -1);
	}
	else if (pg_strcasecmp(my_command->argv[0], "shell") == 0)
	{
		if (my_command->argc < 2)
			syntax_error(source, lineno, my_command->line, my_command->argv[0],
						 "missing command", NULL, -1);
	}
	else
	{
		syntax_error(source, lineno, my_command->line, my_command->argv[0],
					 "invalid command", NULL, -1);
	}

	termPQExpBuffer(&word_buf);

	return my_command;
}

/*
 * Parse a script (either the contents of a file, or a built-in script)
 * and add it to the list of scripts.
 */
static void
ParseScript(const char *script, const char *desc, int weight)
{
	ParsedScript ps;
	PsqlScanState sstate;
	PQExpBufferData line_buf;
	int			alloc_num;
	int			index;

#define COMMANDS_ALLOC_NUM 128
	alloc_num = COMMANDS_ALLOC_NUM;

	/* Initialize all fields of ps */
	ps.desc = desc;
	ps.weight = weight;
	ps.commands = (Command **) pg_malloc(sizeof(Command *) * alloc_num);
	initStats(&ps.stats, 0.0);

	/* Prepare to parse script */
	sstate = psql_scan_create(&pgbench_callbacks);

	/*
	 * Ideally, we'd scan scripts using the encoding and stdstrings settings
	 * we get from a DB connection.  However, without major rearrangement of
	 * pgbench's argument parsing, we can't have a DB connection at the time
	 * we parse scripts.  Using SQL_ASCII (encoding 0) should work well enough
	 * with any backend-safe encoding, though conceivably we could be fooled
	 * if a script file uses a client-only encoding.  We also assume that
	 * stdstrings should be true, which is a bit riskier.
	 */
	psql_scan_setup(sstate, script, strlen(script), 0, true);

	initPQExpBuffer(&line_buf);

	index = 0;

	for (;;)
	{
		PsqlScanResult sr;
		promptStatus_t prompt;
		Command    *command;

		resetPQExpBuffer(&line_buf);

		sr = psql_scan(sstate, &line_buf, &prompt);

		/* If we collected a SQL command, process that */
		command = process_sql_command(&line_buf, desc);
		if (command)
		{
			ps.commands[index] = command;
			index++;

			if (index >= alloc_num)
			{
				alloc_num += COMMANDS_ALLOC_NUM;
				ps.commands = (Command **)
					pg_realloc(ps.commands, sizeof(Command *) * alloc_num);
			}
		}

		/* If we reached a backslash, process that */
		if (sr == PSCAN_BACKSLASH)
		{
			command = process_backslash_command(sstate, desc);
			if (command)
			{
				ps.commands[index] = command;
				index++;

				if (index >= alloc_num)
				{
					alloc_num += COMMANDS_ALLOC_NUM;
					ps.commands = (Command **)
						pg_realloc(ps.commands, sizeof(Command *) * alloc_num);
				}
			}
		}

		/* Done if we reached EOF */
		if (sr == PSCAN_INCOMPLETE || sr == PSCAN_EOL)
			break;
	}

	ps.commands[index] = NULL;

	addScript(ps);

	termPQExpBuffer(&line_buf);
	psql_scan_finish(sstate);
	psql_scan_destroy(sstate);
}

/*
 * Read the entire contents of file fd, and return it in a malloc'd buffer.
 *
 * The buffer will typically be larger than necessary, but we don't care
 * in this program, because we'll free it as soon as we've parsed the script.
 */
static char *
read_file_contents(FILE *fd)
{
	char	   *buf;
	size_t		buflen = BUFSIZ;
	size_t		used = 0;

	buf = (char *) pg_malloc(buflen);

	for (;;)
	{
		size_t		nread;

		nread = fread(buf + used, 1, BUFSIZ, fd);
		used += nread;
		/* If fread() read less than requested, must be EOF or error */
		if (nread < BUFSIZ)
			break;
		/* Enlarge buf so we can read some more */
		buflen += BUFSIZ;
		buf = (char *) pg_realloc(buf, buflen);
	}
	/* There is surely room for a terminator */
	buf[used] = '\0';

	return buf;
}

/*
 * Given a file name, read it and add its script to the list.
 * "-" means to read stdin.
 * NB: filename must be storage that won't disappear.
 */
static void
process_file(const char *filename, int weight)
{
	FILE	   *fd;
	char	   *buf;

	/* Slurp the file contents into "buf" */
	if (strcmp(filename, "-") == 0)
		fd = stdin;
	else if ((fd = fopen(filename, "r")) == NULL)
	{
		fprintf(stderr, "could not open file \"%s\": %s\n",
				filename, strerror(errno));
		exit(1);
	}

	buf = read_file_contents(fd);

	if (ferror(fd))
	{
		fprintf(stderr, "could not read file \"%s\": %s\n",
				filename, strerror(errno));
		exit(1);
	}

	if (fd != stdin)
		fclose(fd);

	ParseScript(buf, filename, weight);

	free(buf);
}

/* Parse the given builtin script and add it to the list. */
static void
process_builtin(const BuiltinScript *bi, int weight)
{
	ParseScript(bi->script, bi->desc, weight);
}

/* show available builtin scripts */
static void
listAvailableScripts(void)
{
	int			i;

	fprintf(stderr, "Available builtin scripts:\n");
	for (i = 0; i < lengthof(builtin_script); i++)
		fprintf(stderr, "\t%s\n", builtin_script[i].name);
	fprintf(stderr, "\n");
}

/* return builtin script "name" if unambiguous, fails if not found */
static const BuiltinScript *
findBuiltin(const char *name)
{
	int			i,
				found = 0,
				len = strlen(name);
	const BuiltinScript *result = NULL;

	for (i = 0; i < lengthof(builtin_script); i++)
	{
		if (strncmp(builtin_script[i].name, name, len) == 0)
		{
			result = &builtin_script[i];
			found++;
		}
	}

	/* ok, unambiguous result */
	if (found == 1)
		return result;

	/* error cases */
	if (found == 0)
		fprintf(stderr, "no builtin script found for name \"%s\"\n", name);
	else	/* found > 1 */
		fprintf(stderr,
				"ambiguous builtin name: %d builtin scripts found for prefix \"%s\"\n", found, name);

	listAvailableScripts();
	exit(1);
}

/*
 * Determine the weight specification from a script option (-b, -f), if any,
 * and return it as an integer (1 is returned if there's no weight).  The
 * script name is returned in *script as a malloc'd string.
 */
static int
parseScriptWeight(const char *option, char **script)
{
	char	   *sep;
	int			weight;

	if ((sep = strrchr(option, WSEP)))
	{
		int			namelen = sep - option;
		long		wtmp;
		char	   *badp;

		/* generate the script name */
		*script = pg_malloc(namelen + 1);
		strncpy(*script, option, namelen);
		(*script)[namelen] = '\0';

		/* process digits of the weight spec */
		errno = 0;
		wtmp = strtol(sep + 1, &badp, 10);
		if (errno != 0 || badp == sep + 1 || *badp != '\0')
		{
			fprintf(stderr, "invalid weight specification: %s\n", sep);
			exit(1);
		}
		if (wtmp > INT_MAX || wtmp < 0)
		{
			fprintf(stderr,
			"weight specification out of range (0 .. %u): " INT64_FORMAT "\n",
					INT_MAX, (int64) wtmp);
			exit(1);
		}
		weight = wtmp;
	}
	else
	{
		*script = pg_strdup(option);
		weight = 1;
	}

	return weight;
}

/* append a script to the list of scripts to process */
static void
addScript(ParsedScript script)
{
	if (script.commands == NULL || script.commands[0] == NULL)
	{
		fprintf(stderr, "empty command list for script \"%s\"\n", script.desc);
		exit(1);
	}

	if (num_scripts >= MAX_SCRIPTS)
	{
		fprintf(stderr, "at most %d SQL scripts are allowed\n", MAX_SCRIPTS);
		exit(1);
	}

	sql_script[num_scripts] = script;
	num_scripts++;
}

static void
printSimpleStats(char *prefix, SimpleStats *ss)
{
	/* print NaN if no transactions where executed */
	double		latency = ss->sum / ss->count;
	double		stddev = sqrt(ss->sum2 / ss->count - latency * latency);

	printf("%s average = %.3f ms\n", prefix, 0.001 * latency);
	printf("%s stddev = %.3f ms\n", prefix, 0.001 * stddev);
}

/* print out results */
static void
printResults(TState *threads, StatsData *total, instr_time total_time,
			 instr_time conn_total_time, int latency_late)
{
	double		time_include,
				tps_include,
				tps_exclude;

	time_include = INSTR_TIME_GET_DOUBLE(total_time);
	tps_include = total->cnt / time_include;
	tps_exclude = total->cnt / (time_include -
						(INSTR_TIME_GET_DOUBLE(conn_total_time) / nclients));

	printf("transaction type: %s\n",
		   num_scripts == 1 ? sql_script[0].desc : "multiple scripts");
	printf("scaling factor: %d\n", scale);
	printf("query mode: %s\n", QUERYMODE[querymode]);
	printf("number of clients: %d\n", nclients);
	printf("number of threads: %d\n", nthreads);
	if (duration <= 0)
	{
		printf("number of transactions per client: %d\n", nxacts);
		printf("number of transactions actually processed: " INT64_FORMAT "/%d\n",
			   total->cnt, nxacts * nclients);
	}
	else
	{
		printf("duration: %d s\n", duration);
		printf("number of transactions actually processed: " INT64_FORMAT "\n",
			   total->cnt);
	}

	/* Remaining stats are nonsensical if we failed to execute any xacts */
	if (total->cnt <= 0)
		return;

	if (throttle_delay && latency_limit)
		printf("number of transactions skipped: " INT64_FORMAT " (%.3f %%)\n",
			   total->skipped,
			   100.0 * total->skipped / (total->skipped + total->cnt));

	if (latency_limit)
		printf("number of transactions above the %.1f ms latency limit: %d (%.3f %%)\n",
			   latency_limit / 1000.0, latency_late,
			   100.0 * latency_late / (total->skipped + total->cnt));

	if (throttle_delay || progress || latency_limit)
		printSimpleStats("latency", &total->latency);
	else
		/* only an average latency computed from the duration is available */
		printf("latency average: %.3f ms\n",
			   1000.0 * duration * nclients / total->cnt);

	if (throttle_delay)
	{
		/*
		 * Report average transaction lag under rate limit throttling.  This
		 * is the delay between scheduled and actual start times for the
		 * transaction.  The measured lag may be caused by thread/client load,
		 * the database load, or the Poisson throttling process.
		 */
		printf("rate limit schedule lag: avg %.3f (max %.3f) ms\n",
			   0.001 * total->lag.sum / total->cnt, 0.001 * total->lag.max);
	}

	printf("tps = %f (including connections establishing)\n", tps_include);
	printf("tps = %f (excluding connections establishing)\n", tps_exclude);

	/* Report per-script/command statistics */
	if (per_script_stats || latency_limit || is_latencies)
	{
		int			i;

		for (i = 0; i < num_scripts; i++)
		{
			if (num_scripts > 1)
				printf("SQL script %d: %s\n"
					   " - weight = %d (targets %.1f%% of total)\n"
					   " - " INT64_FORMAT " transactions (%.1f%% of total, tps = %f)\n",
					   i + 1, sql_script[i].desc,
					   sql_script[i].weight,
					   100.0 * sql_script[i].weight / total_weight,
					   sql_script[i].stats.cnt,
					   100.0 * sql_script[i].stats.cnt / total->cnt,
					   sql_script[i].stats.cnt / time_include);
			else
				printf("script statistics:\n");

			if (latency_limit)
				printf(" - number of transactions skipped: " INT64_FORMAT " (%.3f%%)\n",
					   sql_script[i].stats.skipped,
					   100.0 * sql_script[i].stats.skipped /
					(sql_script[i].stats.skipped + sql_script[i].stats.cnt));

			if (num_scripts > 1)
				printSimpleStats(" - latency", &sql_script[i].stats.latency);

			/* Report per-command latencies */
			if (is_latencies)
			{
				Command   **commands;

				printf(" - statement latencies in milliseconds:\n");

				for (commands = sql_script[i].commands;
					 *commands != NULL;
					 commands++)
					printf("   %11.3f  %s\n",
						   1000.0 * (*commands)->stats.sum /
						   (*commands)->stats.count,
						   (*commands)->line);
			}
		}
	}
}


int
main(int argc, char **argv)
{
	static struct option long_options[] = {
		/* systematic long/short named options */
		{"tpc-b", no_argument, NULL, 'b'},
		{"client", required_argument, NULL, 'c'},
		{"connect", no_argument, NULL, 'C'},
		{"debug", no_argument, NULL, 'd'},
		{"define", required_argument, NULL, 'D'},
		{"file", required_argument, NULL, 'f'},
		{"fillfactor", required_argument, NULL, 'F'},
		{"host", required_argument, NULL, 'h'},
		{"initialize", no_argument, NULL, 'i'},
		{"jobs", required_argument, NULL, 'j'},
		{"log", no_argument, NULL, 'l'},
		{"latency-limit", required_argument, NULL, 'L'},
		{"no-vacuum", no_argument, NULL, 'n'},
		{"port", required_argument, NULL, 'p'},
		{"progress", required_argument, NULL, 'P'},
		{"protocol", required_argument, NULL, 'M'},
		{"quiet", no_argument, NULL, 'q'},
		{"report-latencies", no_argument, NULL, 'r'},
		{"rate", required_argument, NULL, 'R'},
		{"scale", required_argument, NULL, 's'},
		{"select-only", no_argument, NULL, 'S'},
		{"skip-some-updates", no_argument, NULL, 'N'},
		{"time", required_argument, NULL, 'T'},
		{"transactions", required_argument, NULL, 't'},
		{"username", required_argument, NULL, 'U'},
		{"vacuum-all", no_argument, NULL, 'v'},
		/* long-named only options */
		{"foreign-keys", no_argument, &foreign_keys, 1},
		{"index-tablespace", required_argument, NULL, 3},
		{"tablespace", required_argument, NULL, 2},
		{"unlogged-tables", no_argument, &unlogged_tables, 1},
		{"sampling-rate", required_argument, NULL, 4},
		{"aggregate-interval", required_argument, NULL, 5},
		{"progress-timestamp", no_argument, NULL, 6},
		{NULL, 0, NULL, 0}
	};

	int			c;
	int			is_init_mode = 0;		/* initialize mode? */
	int			is_no_vacuum = 0;		/* no vacuum at all before testing? */
	int			do_vacuum_accounts = 0; /* do vacuum accounts before testing? */
	int			optindex;
	bool		scale_given = false;

	bool		benchmarking_option_set = false;
	bool		initialization_option_set = false;
	bool		internal_script_used = false;

	CState	   *state;			/* status of clients */
	TState	   *threads;		/* array of thread */

	instr_time	start_time;		/* start up time */
	instr_time	total_time;
	instr_time	conn_total_time;
	int64		latency_late = 0;
	StatsData	stats;
	int			weight;

	int			i;
	int			nclients_dealt;

#ifdef HAVE_GETRLIMIT
	struct rlimit rlim;
#endif

	PGconn	   *con;
	PGresult   *res;
	char	   *env;

	progname = get_progname(argv[0]);

	if (argc > 1)
	{
		if (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-?") == 0)
		{
			usage();
			exit(0);
		}
		if (strcmp(argv[1], "--version") == 0 || strcmp(argv[1], "-V") == 0)
		{
			puts("pgbench (PostgreSQL) " PG_VERSION);
			exit(0);
		}
	}

#ifdef WIN32
	/* stderr is buffered on Win32. */
	setvbuf(stderr, NULL, _IONBF, 0);
#endif

	if ((env = getenv("PGHOST")) != NULL && *env != '\0')
		pghost = env;
	if ((env = getenv("PGPORT")) != NULL && *env != '\0')
		pgport = env;
	else if ((env = getenv("PGUSER")) != NULL && *env != '\0')
		login = env;

	state = (CState *) pg_malloc(sizeof(CState));
	memset(state, 0, sizeof(CState));

	while ((c = getopt_long(argc, argv, "ih:nvp:dqb:SNc:j:Crs:t:T:U:lf:D:F:M:P:R:L:", long_options, &optindex)) != -1)
	{
		char	   *script;

		switch (c)
		{
			case 'i':
				is_init_mode++;
				break;
			case 'h':
				pghost = pg_strdup(optarg);
				break;
			case 'n':
				is_no_vacuum++;
				break;
			case 'v':
				do_vacuum_accounts++;
				break;
			case 'p':
				pgport = pg_strdup(optarg);
				break;
			case 'd':
				debug++;
				break;
			case 'c':
				benchmarking_option_set = true;
				nclients = atoi(optarg);
				if (nclients <= 0 || nclients > MAXCLIENTS)
				{
					fprintf(stderr, "invalid number of clients: \"%s\"\n",
							optarg);
					exit(1);
				}
#ifdef HAVE_GETRLIMIT
#ifdef RLIMIT_NOFILE			/* most platforms use RLIMIT_NOFILE */
				if (getrlimit(RLIMIT_NOFILE, &rlim) == -1)
#else							/* but BSD doesn't ... */
				if (getrlimit(RLIMIT_OFILE, &rlim) == -1)
#endif   /* RLIMIT_NOFILE */
				{
					fprintf(stderr, "getrlimit failed: %s\n", strerror(errno));
					exit(1);
				}
				if (rlim.rlim_cur < nclients + 3)
				{
					fprintf(stderr, "need at least %d open files, but system limit is %ld\n",
							nclients + 3, (long) rlim.rlim_cur);
					fprintf(stderr, "Reduce number of clients, or use limit/ulimit to increase the system limit.\n");
					exit(1);
				}
#endif   /* HAVE_GETRLIMIT */
				break;
			case 'j':			/* jobs */
				benchmarking_option_set = true;
				nthreads = atoi(optarg);
				if (nthreads <= 0)
				{
					fprintf(stderr, "invalid number of threads: \"%s\"\n",
							optarg);
					exit(1);
				}
#ifndef ENABLE_THREAD_SAFETY
				if (nthreads != 1)
				{
					fprintf(stderr, "threads are not supported on this platform; use -j1\n");
					exit(1);
				}
#endif   /* !ENABLE_THREAD_SAFETY */
				break;
			case 'C':
				benchmarking_option_set = true;
				is_connect = true;
				break;
			case 'r':
				benchmarking_option_set = true;
				per_script_stats = true;
				is_latencies = true;
				break;
			case 's':
				scale_given = true;
				scale = atoi(optarg);
				if (scale <= 0)
				{
					fprintf(stderr, "invalid scaling factor: \"%s\"\n", optarg);
					exit(1);
				}
				break;
			case 't':
				benchmarking_option_set = true;
				if (duration > 0)
				{
					fprintf(stderr, "specify either a number of transactions (-t) or a duration (-T), not both\n");
					exit(1);
				}
				nxacts = atoi(optarg);
				if (nxacts <= 0)
				{
					fprintf(stderr, "invalid number of transactions: \"%s\"\n",
							optarg);
					exit(1);
				}
				break;
			case 'T':
				benchmarking_option_set = true;
				if (nxacts > 0)
				{
					fprintf(stderr, "specify either a number of transactions (-t) or a duration (-T), not both\n");
					exit(1);
				}
				duration = atoi(optarg);
				if (duration <= 0)
				{
					fprintf(stderr, "invalid duration: \"%s\"\n", optarg);
					exit(1);
				}
				break;
			case 'U':
				login = pg_strdup(optarg);
				break;
			case 'l':
				benchmarking_option_set = true;
				use_log = true;
				break;
			case 'q':
				initialization_option_set = true;
				use_quiet = true;
				break;

			case 'b':
				if (strcmp(optarg, "list") == 0)
				{
					listAvailableScripts();
					exit(0);
				}

				weight = parseScriptWeight(optarg, &script);
				process_builtin(findBuiltin(script), weight);
				benchmarking_option_set = true;
				internal_script_used = true;
				break;

			case 'S':
				process_builtin(findBuiltin("select-only"), 1);
				benchmarking_option_set = true;
				internal_script_used = true;
				break;
			case 'N':
				process_builtin(findBuiltin("simple-update"), 1);
				benchmarking_option_set = true;
				internal_script_used = true;
				break;
			case 'f':
				weight = parseScriptWeight(optarg, &script);
				process_file(script, weight);
				benchmarking_option_set = true;
				break;
			case 'D':
				{
					char	   *p;

					benchmarking_option_set = true;

					if ((p = strchr(optarg, '=')) == NULL || p == optarg || *(p + 1) == '\0')
					{
						fprintf(stderr, "invalid variable definition: \"%s\"\n",
								optarg);
						exit(1);
					}

					*p++ = '\0';
					if (!putVariable(&state[0], "option", optarg, p))
						exit(1);
				}
				break;
			case 'F':
				initialization_option_set = true;
				fillfactor = atoi(optarg);
				if (fillfactor < 10 || fillfactor > 100)
				{
					fprintf(stderr, "invalid fillfactor: \"%s\"\n", optarg);
					exit(1);
				}
				break;
			case 'M':
				benchmarking_option_set = true;
				if (num_scripts > 0)
				{
					fprintf(stderr, "query mode (-M) should be specified before any transaction scripts (-f or -b)\n");
					exit(1);
				}
				for (querymode = 0; querymode < NUM_QUERYMODE; querymode++)
					if (strcmp(optarg, QUERYMODE[querymode]) == 0)
						break;
				if (querymode >= NUM_QUERYMODE)
				{
					fprintf(stderr, "invalid query mode (-M): \"%s\"\n",
							optarg);
					exit(1);
				}
				break;
			case 'P':
				benchmarking_option_set = true;
				progress = atoi(optarg);
				if (progress <= 0)
				{
					fprintf(stderr, "invalid thread progress delay: \"%s\"\n",
							optarg);
					exit(1);
				}
				break;
			case 'R':
				{
					/* get a double from the beginning of option value */
					double		throttle_value = atof(optarg);

					benchmarking_option_set = true;

					if (throttle_value <= 0.0)
					{
						fprintf(stderr, "invalid rate limit: \"%s\"\n", optarg);
						exit(1);
					}
					/* Invert rate limit into a time offset */
					throttle_delay = (int64) (1000000.0 / throttle_value);
				}
				break;
			case 'L':
				{
					double		limit_ms = atof(optarg);

					if (limit_ms <= 0.0)
					{
						fprintf(stderr, "invalid latency limit: \"%s\"\n",
								optarg);
						exit(1);
					}
					benchmarking_option_set = true;
					latency_limit = (int64) (limit_ms * 1000);
				}
				break;
			case 0:
				/* This covers long options which take no argument. */
				if (foreign_keys || unlogged_tables)
					initialization_option_set = true;
				break;
			case 2:				/* tablespace */
				initialization_option_set = true;
				tablespace = pg_strdup(optarg);
				break;
			case 3:				/* index-tablespace */
				initialization_option_set = true;
				index_tablespace = pg_strdup(optarg);
				break;
			case 4:
				benchmarking_option_set = true;
				sample_rate = atof(optarg);
				if (sample_rate <= 0.0 || sample_rate > 1.0)
				{
					fprintf(stderr, "invalid sampling rate: \"%s\"\n", optarg);
					exit(1);
				}
				break;
			case 5:
#ifdef WIN32
				fprintf(stderr, "--aggregate-interval is not currently supported on Windows\n");
				exit(1);
#else
				benchmarking_option_set = true;
				agg_interval = atoi(optarg);
				if (agg_interval <= 0)
				{
					fprintf(stderr, "invalid number of seconds for aggregation: \"%s\"\n",
							optarg);
					exit(1);
				}
#endif
				break;
			case 6:
				progress_timestamp = true;
				benchmarking_option_set = true;
				break;
			default:
				fprintf(stderr, _("Try \"%s --help\" for more information.\n"), progname);
				exit(1);
				break;
		}
	}

	/* set default script if none */
	if (num_scripts == 0 && !is_init_mode)
	{
		process_builtin(findBuiltin("tpcb-like"), 1);
		benchmarking_option_set = true;
		internal_script_used = true;
	}

	/* compute total_weight */
	for (i = 0; i < num_scripts; i++)
		/* cannot overflow: weight is 32b, total_weight 64b */
		total_weight += sql_script[i].weight;

	if (total_weight == 0 && !is_init_mode)
	{
		fprintf(stderr, "total script weight must not be zero\n");
		exit(1);
	}

	/* show per script stats if several scripts are used */
	if (num_scripts > 1)
		per_script_stats = true;

	/*
	 * Don't need more threads than there are clients.  (This is not merely an
	 * optimization; throttle_delay is calculated incorrectly below if some
	 * threads have no clients assigned to them.)
	 */
	if (nthreads > nclients)
		nthreads = nclients;

	/* compute a per thread delay */
	throttle_delay *= nthreads;

	if (argc > optind)
		dbName = argv[optind];
	else
	{
		if ((env = getenv("PGDATABASE")) != NULL && *env != '\0')
			dbName = env;
		else if (login != NULL && *login != '\0')
			dbName = login;
		else
			dbName = "";
	}

	if (is_init_mode)
	{
		if (benchmarking_option_set)
		{
			fprintf(stderr, "some of the specified options cannot be used in initialization (-i) mode\n");
			exit(1);
		}

		init(is_no_vacuum);
		exit(0);
	}
	else
	{
		if (initialization_option_set)
		{
			fprintf(stderr, "some of the specified options cannot be used in benchmarking mode\n");
			exit(1);
		}
	}

	/* Use DEFAULT_NXACTS if neither nxacts nor duration is specified. */
	if (nxacts <= 0 && duration <= 0)
		nxacts = DEFAULT_NXACTS;

	/* --sampling-rate may be used only with -l */
	if (sample_rate > 0.0 && !use_log)
	{
		fprintf(stderr, "log sampling (--sampling-rate) is allowed only when logging transactions (-l)\n");
		exit(1);
	}

	/* --sampling-rate may not be used with --aggregate-interval */
	if (sample_rate > 0.0 && agg_interval > 0)
	{
		fprintf(stderr, "log sampling (--sampling-rate) and aggregation (--aggregate-interval) cannot be used at the same time\n");
		exit(1);
	}

	if (agg_interval > 0 && !use_log)
	{
		fprintf(stderr, "log aggregation is allowed only when actually logging transactions\n");
		exit(1);
	}

	if (duration > 0 && agg_interval > duration)
	{
		fprintf(stderr, "number of seconds for aggregation (%d) must not be higher than test duration (%d)\n", agg_interval, duration);
		exit(1);
	}

	if (duration > 0 && agg_interval > 0 && duration % agg_interval != 0)
	{
		fprintf(stderr, "duration (%d) must be a multiple of aggregation interval (%d)\n", duration, agg_interval);
		exit(1);
	}

	/*
	 * save main process id in the global variable because process id will be
	 * changed after fork.
	 */
	main_pid = (int) getpid();

	if (nclients > 1)
	{
		state = (CState *) pg_realloc(state, sizeof(CState) * nclients);
		memset(state + 1, 0, sizeof(CState) * (nclients - 1));

		/* copy any -D switch values to all clients */
		for (i = 1; i < nclients; i++)
		{
			int			j;

			state[i].id = i;
			for (j = 0; j < state[0].nvariables; j++)
			{
				Variable   *var = &state[0].variables[j];

				if (var->is_numeric)
				{
					if (!putVariableNumber(&state[i], "startup",
										   var->name, &var->num_value))
						exit(1);
				}
				else
				{
					if (!putVariable(&state[i], "startup",
									 var->name, var->value))
						exit(1);
				}
			}
		}
	}

	if (debug)
	{
		if (duration <= 0)
			printf("pghost: %s pgport: %s nclients: %d nxacts: %d dbName: %s\n",
				   pghost, pgport, nclients, nxacts, dbName);
		else
			printf("pghost: %s pgport: %s nclients: %d duration: %d dbName: %s\n",
				   pghost, pgport, nclients, duration, dbName);
	}

	/* opening connection... */
	con = doConnect();
	if (con == NULL)
		exit(1);

	if (PQstatus(con) == CONNECTION_BAD)
	{
		fprintf(stderr, "connection to database \"%s\" failed\n", dbName);
		fprintf(stderr, "%s", PQerrorMessage(con));
		exit(1);
	}

	if (internal_script_used)
	{
		/*
		 * get the scaling factor that should be same as count(*) from
		 * pgbench_branches if this is not a custom query
		 */
		res = PQexec(con, "select count(*) from pgbench_branches");
		if (PQresultStatus(res) != PGRES_TUPLES_OK)
		{
			char	   *sqlState = PQresultErrorField(res, PG_DIAG_SQLSTATE);

			fprintf(stderr, "%s", PQerrorMessage(con));
			if (sqlState && strcmp(sqlState, ERRCODE_UNDEFINED_TABLE) == 0)
			{
				fprintf(stderr, "Perhaps you need to do initialization (\"pgbench -i\") in database \"%s\"\n", PQdb(con));
			}

			exit(1);
		}
		scale = atoi(PQgetvalue(res, 0, 0));
		if (scale < 0)
		{
			fprintf(stderr, "invalid count(*) from pgbench_branches: \"%s\"\n",
					PQgetvalue(res, 0, 0));
			exit(1);
		}
		PQclear(res);

		/* warn if we override user-given -s switch */
		if (scale_given)
			fprintf(stderr,
					"scale option ignored, using count from pgbench_branches table (%d)\n",
					scale);
	}

	/*
	 * :scale variables normally get -s or database scale, but don't override
	 * an explicit -D switch
	 */
	if (lookupVariable(&state[0], "scale") == NULL)
	{
		for (i = 0; i < nclients; i++)
		{
			if (!putVariableInt(&state[i], "startup", "scale", scale))
				exit(1);
		}
	}

	/*
	 * Define a :client_id variable that is unique per connection. But don't
	 * override an explicit -D switch.
	 */
	if (lookupVariable(&state[0], "client_id") == NULL)
	{
		for (i = 0; i < nclients; i++)
		{
			if (!putVariableInt(&state[i], "startup", "client_id", i))
				exit(1);
		}
	}

	if (!is_no_vacuum)
	{
		fprintf(stderr, "starting vacuum...");
		tryExecuteStatement(con, "vacuum pgbench_branches");
		tryExecuteStatement(con, "vacuum pgbench_tellers");
		tryExecuteStatement(con, "truncate pgbench_history");
		fprintf(stderr, "end.\n");

		if (do_vacuum_accounts)
		{
			fprintf(stderr, "starting vacuum pgbench_accounts...");
			tryExecuteStatement(con, "vacuum analyze pgbench_accounts");
			fprintf(stderr, "end.\n");
		}
	}
	PQfinish(con);

	/* set random seed */
	INSTR_TIME_SET_CURRENT(start_time);
	srandom((unsigned int) INSTR_TIME_GET_MICROSEC(start_time));

	/* set up thread data structures */
	threads = (TState *) pg_malloc(sizeof(TState) * nthreads);
	nclients_dealt = 0;

	for (i = 0; i < nthreads; i++)
	{
		TState	   *thread = &threads[i];

		thread->tid = i;
		thread->state = &state[nclients_dealt];
		thread->nstate =
			(nclients - nclients_dealt + nthreads - i - 1) / (nthreads - i);
		thread->random_state[0] = random();
		thread->random_state[1] = random();
		thread->random_state[2] = random();
		thread->logfile = NULL; /* filled in later */
		thread->latency_late = 0;
		initStats(&thread->stats, 0.0);

		nclients_dealt += thread->nstate;
	}

	/* all clients must be assigned to a thread */
	Assert(nclients_dealt == nclients);

	/* get start up time */
	INSTR_TIME_SET_CURRENT(start_time);

	/* set alarm if duration is specified. */
	if (duration > 0)
		setalarm(duration);

	/* start threads */
#ifdef ENABLE_THREAD_SAFETY
	for (i = 0; i < nthreads; i++)
	{
		TState	   *thread = &threads[i];

		INSTR_TIME_SET_CURRENT(thread->start_time);

		/* compute when to stop */
		if (duration > 0)
			end_time = INSTR_TIME_GET_MICROSEC(thread->start_time) +
				(int64) 1000000 *duration;

		/* the first thread (i = 0) is executed by main thread */
		if (i > 0)
		{
			int			err = pthread_create(&thread->thread, NULL, threadRun, thread);

			if (err != 0 || thread->thread == INVALID_THREAD)
			{
				fprintf(stderr, "could not create thread: %s\n", strerror(err));
				exit(1);
			}
		}
		else
		{
			thread->thread = INVALID_THREAD;
		}
	}
#else
	INSTR_TIME_SET_CURRENT(threads[0].start_time);
	/* compute when to stop */
	if (duration > 0)
		end_time = INSTR_TIME_GET_MICROSEC(threads[0].start_time) +
			(int64) 1000000 *duration;
	threads[0].thread = INVALID_THREAD;
#endif   /* ENABLE_THREAD_SAFETY */

	/* wait for threads and accumulate results */
	initStats(&stats, 0.0);
	INSTR_TIME_SET_ZERO(conn_total_time);
	for (i = 0; i < nthreads; i++)
	{
		TState	   *thread = &threads[i];

#ifdef ENABLE_THREAD_SAFETY
		if (threads[i].thread == INVALID_THREAD)
			/* actually run this thread directly in the main thread */
			(void) threadRun(thread);
		else
			/* wait of other threads. should check that 0 is returned? */
			pthread_join(thread->thread, NULL);
#else
		(void) threadRun(thread);
#endif   /* ENABLE_THREAD_SAFETY */

		/* aggregate thread level stats */
		mergeSimpleStats(&stats.latency, &thread->stats.latency);
		mergeSimpleStats(&stats.lag, &thread->stats.lag);
		stats.cnt += thread->stats.cnt;
		stats.skipped += thread->stats.skipped;
		latency_late += thread->latency_late;
		INSTR_TIME_ADD(conn_total_time, thread->conn_time);
	}
	disconnect_all(state, nclients);

	/*
	 * XXX We compute results as though every client of every thread started
	 * and finished at the same time.  That model can diverge noticeably from
	 * reality for a short benchmark run involving relatively many threads.
	 * The first thread may process notably many transactions before the last
	 * thread begins.  Improving the model alone would bring limited benefit,
	 * because performance during those periods of partial thread count can
	 * easily exceed steady state performance.  This is one of the many ways
	 * short runs convey deceptive performance figures.
	 */
	INSTR_TIME_SET_CURRENT(total_time);
	INSTR_TIME_SUBTRACT(total_time, start_time);
	printResults(threads, &stats, total_time, conn_total_time, latency_late);

	return 0;
}

static void *
threadRun(void *arg)
{
	TState	   *thread = (TState *) arg;
	CState	   *state = thread->state;
	instr_time	start,
				end;
	int			nstate = thread->nstate;
	int			remains = nstate;		/* number of remaining clients */
	int			i;

	/* for reporting progress: */
	int64		thread_start = INSTR_TIME_GET_MICROSEC(thread->start_time);
	int64		last_report = thread_start;
	int64		next_report = last_report + (int64) progress * 1000000;
	StatsData	last,
				aggs;

	/*
	 * Initialize throttling rate target for all of the thread's clients.  It
	 * might be a little more accurate to reset thread->start_time here too.
	 * The possible drift seems too small relative to typical throttle delay
	 * times to worry about it.
	 */
	INSTR_TIME_SET_CURRENT(start);
	thread->throttle_trigger = INSTR_TIME_GET_MICROSEC(start);

	INSTR_TIME_SET_ZERO(thread->conn_time);

	/* open log file if requested */
	if (use_log)
	{
		char		logpath[64];

		if (thread->tid == 0)
			snprintf(logpath, sizeof(logpath), "pgbench_log.%d", main_pid);
		else
			snprintf(logpath, sizeof(logpath), "pgbench_log.%d.%d", main_pid, thread->tid);
		thread->logfile = fopen(logpath, "w");

		if (thread->logfile == NULL)
		{
			fprintf(stderr, "could not open logfile \"%s\": %s\n",
					logpath, strerror(errno));
			goto done;
		}
	}

	if (!is_connect)
	{
		/* make connections to the database */
		for (i = 0; i < nstate; i++)
		{
			if ((state[i].con = doConnect()) == NULL)
				goto done;
		}
	}

	/* time after thread and connections set up */
	INSTR_TIME_SET_CURRENT(thread->conn_time);
	INSTR_TIME_SUBTRACT(thread->conn_time, thread->start_time);

	initStats(&aggs, INSTR_TIME_GET_DOUBLE(thread->start_time));
	last = aggs;

	/* send start up queries in async manner */
	for (i = 0; i < nstate; i++)
	{
		CState	   *st = &state[i];
		int			prev_ecnt = st->ecnt;
		Command   **commands;

		st->use_file = chooseScript(thread);
		commands = sql_script[st->use_file].commands;
		if (debug)
			fprintf(stderr, "client %d executing script \"%s\"\n", st->id,
					sql_script[st->use_file].desc);
		if (!doCustom(thread, st, &aggs))
			remains--;			/* I've aborted */

		if (st->ecnt > prev_ecnt && commands[st->state]->type == META_COMMAND)
		{
			fprintf(stderr, "client %d aborted in state %d; execution of meta-command failed\n",
					i, st->state);
			remains--;			/* I've aborted */
			PQfinish(st->con);
			st->con = NULL;
		}
	}

	while (remains > 0)
	{
		fd_set		input_mask;
		int			maxsock;	/* max socket number to be waited */
		int64		now_usec = 0;
		int64		min_usec;

		FD_ZERO(&input_mask);

		maxsock = -1;
		min_usec = PG_INT64_MAX;
		for (i = 0; i < nstate; i++)
		{
			CState	   *st = &state[i];
			Command   **commands = sql_script[st->use_file].commands;
			int			sock;

			if (st->con == NULL)
			{
				continue;
			}
			else if (st->sleeping)
			{
				if (st->throttling && timer_exceeded)
				{
					/* interrupt client which has not started a transaction */
					remains--;
					st->sleeping = false;
					st->throttling = false;
					PQfinish(st->con);
					st->con = NULL;
					continue;
				}
				else	/* just a nap from the script */
				{
					int			this_usec;

					if (min_usec == PG_INT64_MAX)
					{
						instr_time	now;

						INSTR_TIME_SET_CURRENT(now);
						now_usec = INSTR_TIME_GET_MICROSEC(now);
					}

					this_usec = st->txn_scheduled - now_usec;
					if (min_usec > this_usec)
						min_usec = this_usec;
				}
			}
			else if (commands[st->state]->type == META_COMMAND)
			{
				min_usec = 0;	/* the connection is ready to run */
				break;
			}

			sock = PQsocket(st->con);
			if (sock < 0)
			{
				fprintf(stderr, "invalid socket: %s", PQerrorMessage(st->con));
				goto done;
			}

			FD_SET(sock, &input_mask);

			if (maxsock < sock)
				maxsock = sock;
		}

		/* also wake up to print the next progress report on time */
		if (progress && min_usec > 0 && thread->tid == 0)
		{
			/* get current time if needed */
			if (now_usec == 0)
			{
				instr_time	now;

				INSTR_TIME_SET_CURRENT(now);
				now_usec = INSTR_TIME_GET_MICROSEC(now);
			}

			if (now_usec >= next_report)
				min_usec = 0;
			else if ((next_report - now_usec) < min_usec)
				min_usec = next_report - now_usec;
		}

		/*
		 * Sleep until we receive data from the server, or a nap-time
		 * specified in the script ends, or it's time to print a progress
		 * report.
		 */
		if (min_usec > 0 && maxsock != -1)
		{
			int			nsocks; /* return from select(2) */

			if (min_usec != PG_INT64_MAX)
			{
				struct timeval timeout;

				timeout.tv_sec = min_usec / 1000000;
				timeout.tv_usec = min_usec % 1000000;
				nsocks = select(maxsock + 1, &input_mask, NULL, NULL, &timeout);
			}
			else
				nsocks = select(maxsock + 1, &input_mask, NULL, NULL, NULL);
			if (nsocks < 0)
			{
				if (errno == EINTR)
					continue;
				/* must be something wrong */
				fprintf(stderr, "select() failed: %s\n", strerror(errno));
				goto done;
			}
		}

		/* ok, backend returns reply */
		for (i = 0; i < nstate; i++)
		{
			CState	   *st = &state[i];
			Command   **commands = sql_script[st->use_file].commands;
			int			prev_ecnt = st->ecnt;

			if (st->con)
			{
				int			sock = PQsocket(st->con);

				if (sock < 0)
				{
					fprintf(stderr, "invalid socket: %s",
							PQerrorMessage(st->con));
					goto done;
				}
				if (FD_ISSET(sock, &input_mask) ||
					commands[st->state]->type == META_COMMAND)
				{
					if (!doCustom(thread, st, &aggs))
						remains--;		/* I've aborted */
				}
			}

			if (st->ecnt > prev_ecnt && commands[st->state]->type == META_COMMAND)
			{
				fprintf(stderr, "client %d aborted in state %d; execution of meta-command failed\n",
						i, st->state);
				remains--;		/* I've aborted */
				PQfinish(st->con);
				st->con = NULL;
			}
		}

		/* progress report by thread 0 for all threads */
		if (progress && thread->tid == 0)
		{
			instr_time	now_time;
			int64		now;

			INSTR_TIME_SET_CURRENT(now_time);
			now = INSTR_TIME_GET_MICROSEC(now_time);
			if (now >= next_report)
			{
				/* generate and show report */
				StatsData	cur;
				int64		run = now - last_report;
				double		tps,
							total_run,
							latency,
							sqlat,
							lag,
							stdev;
				char		tbuf[64];

				/*
				 * Add up the statistics of all threads.
				 *
				 * XXX: No locking. There is no guarantee that we get an
				 * atomic snapshot of the transaction count and latencies, so
				 * these figures can well be off by a small amount. The
				 * progress is report's purpose is to give a quick overview of
				 * how the test is going, so that shouldn't matter too much.
				 * (If a read from a 64-bit integer is not atomic, you might
				 * get a "torn" read and completely bogus latencies though!)
				 */
				initStats(&cur, 0.0);
				for (i = 0; i < nthreads; i++)
				{
					mergeSimpleStats(&cur.latency, &thread[i].stats.latency);
					mergeSimpleStats(&cur.lag, &thread[i].stats.lag);
					cur.cnt += thread[i].stats.cnt;
					cur.skipped += thread[i].stats.skipped;
				}

				total_run = (now - thread_start) / 1000000.0;
				tps = 1000000.0 * (cur.cnt - last.cnt) / run;
				latency = 0.001 * (cur.latency.sum - last.latency.sum) /
					(cur.cnt - last.cnt);
				sqlat = 1.0 * (cur.latency.sum2 - last.latency.sum2)
					/ (cur.cnt - last.cnt);
				stdev = 0.001 * sqrt(sqlat - 1000000.0 * latency * latency);
				lag = 0.001 * (cur.lag.sum - last.lag.sum) /
					(cur.cnt - last.cnt);

				if (progress_timestamp)
					sprintf(tbuf, "%.03f s",
							INSTR_TIME_GET_MILLISEC(now_time) / 1000.0);
				else
					sprintf(tbuf, "%.1f s", total_run);

				fprintf(stderr,
						"progress: %s, %.1f tps, lat %.3f ms stddev %.3f",
						tbuf, tps, latency, stdev);

				if (throttle_delay)
				{
					fprintf(stderr, ", lag %.3f ms", lag);
					if (latency_limit)
						fprintf(stderr, ", " INT64_FORMAT " skipped",
								cur.skipped - last.skipped);
				}
				fprintf(stderr, "\n");

				last = cur;
				last_report = now;

				/*
				 * Ensure that the next report is in the future, in case
				 * pgbench/postgres got stuck somewhere.
				 */
				do
				{
					next_report += (int64) progress *1000000;
				} while (now >= next_report);
			}
		}
	}

done:
	INSTR_TIME_SET_CURRENT(start);
	disconnect_all(state, nstate);
	INSTR_TIME_SET_CURRENT(end);
	INSTR_TIME_ACCUM_DIFF(thread->conn_time, end, start);
	if (thread->logfile)
	{
		if (agg_interval)
		{
			/* log aggregated but not yet reported transactions */
			doLog(thread, state, &end, &aggs, false, 0, 0);
		}
		fclose(thread->logfile);
	}
	return NULL;
}

/*
 * Support for duration option: set timer_exceeded after so many seconds.
 */

#ifndef WIN32

static void
handle_sig_alarm(SIGNAL_ARGS)
{
	timer_exceeded = true;
}

static void
setalarm(int seconds)
{
	pqsignal(SIGALRM, handle_sig_alarm);
	alarm(seconds);
}

#else							/* WIN32 */

static VOID CALLBACK
win32_timer_callback(PVOID lpParameter, BOOLEAN TimerOrWaitFired)
{
	timer_exceeded = true;
}

static void
setalarm(int seconds)
{
	HANDLE		queue;
	HANDLE		timer;

	/* This function will be called at most once, so we can cheat a bit. */
	queue = CreateTimerQueue();
	if (seconds > ((DWORD) -1) / 1000 ||
		!CreateTimerQueueTimer(&timer, queue,
							   win32_timer_callback, NULL, seconds * 1000, 0,
							   WT_EXECUTEINTIMERTHREAD | WT_EXECUTEONLYONCE))
	{
		fprintf(stderr, "failed to set timer\n");
		exit(1);
	}
}

/* partial pthread implementation for Windows */

typedef struct win32_pthread
{
	HANDLE		handle;
	void	   *(*routine) (void *);
	void	   *arg;
	void	   *result;
} win32_pthread;

static unsigned __stdcall
win32_pthread_run(void *arg)
{
	win32_pthread *th = (win32_pthread *) arg;

	th->result = th->routine(th->arg);

	return 0;
}

static int
pthread_create(pthread_t *thread,
			   pthread_attr_t *attr,
			   void *(*start_routine) (void *),
			   void *arg)
{
	int			save_errno;
	win32_pthread *th;

	th = (win32_pthread *) pg_malloc(sizeof(win32_pthread));
	th->routine = start_routine;
	th->arg = arg;
	th->result = NULL;

	th->handle = (HANDLE) _beginthreadex(NULL, 0, win32_pthread_run, th, 0, NULL);
	if (th->handle == NULL)
	{
		save_errno = errno;
		free(th);
		return save_errno;
	}

	*thread = th;
	return 0;
}

static int
pthread_join(pthread_t th, void **thread_return)
{
	if (th == NULL || th->handle == NULL)
		return errno = EINVAL;

	if (WaitForSingleObject(th->handle, INFINITE) != WAIT_OBJECT_0)
	{
		_dosmaperr(GetLastError());
		return errno;
	}

	if (thread_return)
		*thread_return = th->result;

	CloseHandle(th->handle);
	free(th);
	return 0;
}

#endif   /* WIN32 */
