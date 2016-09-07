/*-------------------------------------------------------------------------
 *
 * xlogfuncs.c
 *
 * PostgreSQL transaction log manager user interface functions
 *
 * This file contains WAL control and information functions.
 *
 *
 * Portions Copyright (c) 1996-2016, PostgreSQL Global Development Group
 * Portions Copyright (c) 1994, Regents of the University of California
 *
 * src/backend/access/transam/xlogfuncs.c
 *
 *-------------------------------------------------------------------------
 */
#include "postgres.h"

#include "access/htup_details.h"
#include "access/xlog.h"
#include "access/xlog_fn.h"
#include "access/xlog_internal.h"
#include "access/xlogutils.h"
#include "catalog/catalog.h"
#include "catalog/pg_type.h"
#include "funcapi.h"
#include "miscadmin.h"
#include "replication/walreceiver.h"
#include "storage/smgr.h"
#include "utils/builtins.h"
#include "utils/memutils.h"
#include "utils/numeric.h"
#include "utils/guc.h"
#include "utils/pg_lsn.h"
#include "utils/timestamp.h"
#include "utils/tuplestore.h"
#include "storage/fd.h"
#include "storage/ipc.h"


/*
 * Store label file and tablespace map during non-exclusive backups.
 */
static StringInfo label_file;
static StringInfo tblspc_map_file;
static bool exclusive_backup_running = false;
static bool nonexclusive_backup_running = false;

/*
 * Called when the backend exits with a running non-exclusive base backup,
 * to clean up state.
 */
static void
nonexclusive_base_backup_cleanup(int code, Datum arg)
{
	do_pg_abort_backup();
	ereport(WARNING,
			(errmsg("aborting backup due to backend exiting before pg_stop_backup was called")));
}

/*
 * pg_start_backup: set up for taking an on-line backup dump
 *
 * Essentially what this does is to create a backup label file in $PGDATA,
 * where it will be archived as part of the backup dump.  The label file
 * contains the user-supplied label string (typically this would be used
 * to tell where the backup dump will be stored) and the starting time and
 * starting WAL location for the dump.
 *
 * Permission checking for this function is managed through the normal
 * GRANT system.
 */
Datum
pg_start_backup(PG_FUNCTION_ARGS)
{
	text	   *backupid = PG_GETARG_TEXT_P(0);
	bool		fast = PG_GETARG_BOOL(1);
	bool		exclusive = PG_GETARG_BOOL(2);
	char	   *backupidstr;
	XLogRecPtr	startpoint;
	DIR		   *dir;

	backupidstr = text_to_cstring(backupid);

	if (exclusive_backup_running || nonexclusive_backup_running)
		ereport(ERROR,
				(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
				 errmsg("a backup is already in progress in this session")));

	/* Make sure we can open the directory with tablespaces in it */
	dir = AllocateDir("pg_tblspc");
	if (!dir)
		ereport(ERROR,
				(errmsg("could not open directory \"%s\": %m", "pg_tblspc")));

	if (exclusive)
	{
		startpoint = do_pg_start_backup(backupidstr, fast, NULL, NULL,
										dir, NULL, NULL, false, true);
		exclusive_backup_running = true;
	}
	else
	{
		MemoryContext oldcontext;

		/*
		 * Label file and tablespace map file need to be long-lived, since
		 * they are read in pg_stop_backup.
		 */
		oldcontext = MemoryContextSwitchTo(TopMemoryContext);
		label_file = makeStringInfo();
		tblspc_map_file = makeStringInfo();
		MemoryContextSwitchTo(oldcontext);

		startpoint = do_pg_start_backup(backupidstr, fast, NULL, label_file,
									dir, NULL, tblspc_map_file, false, true);
		nonexclusive_backup_running = true;

		before_shmem_exit(nonexclusive_base_backup_cleanup, (Datum) 0);
	}

	FreeDir(dir);

	PG_RETURN_LSN(startpoint);
}

/*
 * pg_stop_backup: finish taking an on-line backup dump
 *
 * We write an end-of-backup WAL record, and remove the backup label file
 * created by pg_start_backup, creating a backup history file in pg_xlog
 * instead (whence it will immediately be archived). The backup history file
 * contains the same info found in the label file, plus the backup-end time
 * and WAL location. Before 9.0, the backup-end time was read from the backup
 * history file at the beginning of archive recovery, but we now use the WAL
 * record for that and the file is for informational and debug purposes only.
 *
 * Note: different from CancelBackup which just cancels online backup mode.
 *
 * Note: this version is only called to stop an exclusive backup. The function
 *		 pg_stop_backup_v2 (overloaded as pg_stop_backup in SQL) is called to
 *		 stop non-exclusive backups.
 *
 * Permission checking for this function is managed through the normal
 * GRANT system.
 */
Datum
pg_stop_backup(PG_FUNCTION_ARGS)
{
	XLogRecPtr	stoppoint;

	if (nonexclusive_backup_running)
		ereport(ERROR,
				(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
				 errmsg("non-exclusive backup in progress"),
				 errhint("Did you mean to use pg_stop_backup('f')?")));

	/*
	 * Exclusive backups were typically started in a different connection, so
	 * don't try to verify that exclusive_backup_running is set in this one.
	 * Actual verification that an exclusive backup is in fact running is
	 * handled inside do_pg_stop_backup.
	 */
	stoppoint = do_pg_stop_backup(NULL, true, NULL);

	exclusive_backup_running = false;

	PG_RETURN_LSN(stoppoint);
}


/*
 * pg_stop_backup_v2: finish taking exclusive or nonexclusive on-line backup.
 *
 * Works the same as pg_stop_backup, except for non-exclusive backups it returns
 * the backup label and tablespace map files as text fields in as part of the
 * resultset.
 *
 * Permission checking for this function is managed through the normal
 * GRANT system.
 */
Datum
pg_stop_backup_v2(PG_FUNCTION_ARGS)
{
	ReturnSetInfo *rsinfo = (ReturnSetInfo *) fcinfo->resultinfo;
	TupleDesc	tupdesc;
	Tuplestorestate *tupstore;
	MemoryContext per_query_ctx;
	MemoryContext oldcontext;
	Datum		values[3];
	bool		nulls[3];

	bool		exclusive = PG_GETARG_BOOL(0);
	XLogRecPtr	stoppoint;

	/* check to see if caller supports us returning a tuplestore */
	if (rsinfo == NULL || !IsA(rsinfo, ReturnSetInfo))
		ereport(ERROR,
				(errcode(ERRCODE_FEATURE_NOT_SUPPORTED),
				 errmsg("set-valued function called in context that cannot accept a set")));
	if (!(rsinfo->allowedModes & SFRM_Materialize))
		ereport(ERROR,
				(errcode(ERRCODE_FEATURE_NOT_SUPPORTED),
				 errmsg("materialize mode required, but it is not " \
						"allowed in this context")));

	/* Build a tuple descriptor for our result type */
	if (get_call_result_type(fcinfo, NULL, &tupdesc) != TYPEFUNC_COMPOSITE)
		elog(ERROR, "return type must be a row type");

	per_query_ctx = rsinfo->econtext->ecxt_per_query_memory;
	oldcontext = MemoryContextSwitchTo(per_query_ctx);

	tupstore = tuplestore_begin_heap(true, false, work_mem);
	rsinfo->returnMode = SFRM_Materialize;
	rsinfo->setResult = tupstore;
	rsinfo->setDesc = tupdesc;

	MemoryContextSwitchTo(oldcontext);

	MemSet(values, 0, sizeof(values));
	MemSet(nulls, 0, sizeof(nulls));

	if (exclusive)
	{
		if (nonexclusive_backup_running)
			ereport(ERROR,
					(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
					 errmsg("non-exclusive backup in progress"),
					 errhint("Did you mean to use pg_stop_backup('f')?")));

		/*
		 * Stop the exclusive backup, and since we're in an exclusive backup
		 * return NULL for both backup_label and tablespace_map.
		 */
		stoppoint = do_pg_stop_backup(NULL, true, NULL);
		exclusive_backup_running = false;

		nulls[1] = true;
		nulls[2] = true;
	}
	else
	{
		if (!nonexclusive_backup_running)
			ereport(ERROR,
					(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
					 errmsg("non-exclusive backup is not in progress"),
					 errhint("Did you mean to use pg_stop_backup('t')?")));

		/*
		 * Stop the non-exclusive backup. Return a copy of the backup label
		 * and tablespace map so they can be written to disk by the caller.
		 */
		stoppoint = do_pg_stop_backup(label_file->data, true, NULL);
		nonexclusive_backup_running = false;
		cancel_before_shmem_exit(nonexclusive_base_backup_cleanup, (Datum) 0);

		values[1] = CStringGetTextDatum(label_file->data);
		values[2] = CStringGetTextDatum(tblspc_map_file->data);

		/* Free structures allocated in TopMemoryContext */
		pfree(label_file->data);
		pfree(label_file);
		label_file = NULL;
		pfree(tblspc_map_file->data);
		pfree(tblspc_map_file);
		tblspc_map_file = NULL;
	}

	/* Stoppoint is included on both exclusive and nonexclusive backups */
	values[0] = LSNGetDatum(stoppoint);

	tuplestore_putvalues(tupstore, tupdesc, values, nulls);
	tuplestore_donestoring(typstore);

	return (Datum) 0;
}

/*
 * pg_switch_xlog: switch to next xlog file
 *
 * Permission checking for this function is managed through the normal
 * GRANT system.
 */
Datum
pg_switch_xlog(PG_FUNCTION_ARGS)
{
	XLogRecPtr	switchpoint;

	if (RecoveryInProgress())
		ereport(ERROR,
				(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
				 errmsg("recovery is in progress"),
				 errhint("WAL control functions cannot be executed during recovery.")));

	switchpoint = RequestXLogSwitch();

	/*
	 * As a convenience, return the WAL location of the switch record
	 */
	PG_RETURN_LSN(switchpoint);
}

/*
 * pg_create_restore_point: a named point for restore
 *
 * Permission checking for this function is managed through the normal
 * GRANT system.
 */
Datum
pg_create_restore_point(PG_FUNCTION_ARGS)
{
	text	   *restore_name = PG_GETARG_TEXT_P(0);
	char	   *restore_name_str;
	XLogRecPtr	restorepoint;

	if (RecoveryInProgress())
		ereport(ERROR,
				(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
				 (errmsg("recovery is in progress"),
				  errhint("WAL control functions cannot be executed during recovery."))));

	if (!XLogIsNeeded())
		ereport(ERROR,
				(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
			 errmsg("WAL level not sufficient for creating a restore point"),
				 errhint("wal_level must be set to \"replica\" or \"logical\" at server start.")));

	restore_name_str = text_to_cstring(restore_name);

	if (strlen(restore_name_str) >= MAXFNAMELEN)
		ereport(ERROR,
				(errcode(ERRCODE_INVALID_PARAMETER_VALUE),
				 errmsg("value too long for restore point (maximum %d characters)", MAXFNAMELEN - 1)));

	restorepoint = XLogRestorePoint(restore_name_str);

	/*
	 * As a convenience, return the WAL location of the restore point record
	 */
	PG_RETURN_LSN(restorepoint);
}

/*
 * Report the current WAL write location (same format as pg_start_backup etc)
 *
 * This is useful for determining how much of WAL is visible to an external
 * archiving process.  Note that the data before this point is written out
 * to the kernel, but is not necessarily synced to disk.
 */
Datum
pg_current_xlog_location(PG_FUNCTION_ARGS)
{
	XLogRecPtr	current_recptr;

	if (RecoveryInProgress())
		ereport(ERROR,
				(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
				 errmsg("recovery is in progress"),
				 errhint("WAL control functions cannot be executed during recovery.")));

	current_recptr = GetXLogWriteRecPtr();

	PG_RETURN_LSN(current_recptr);
}

/*
 * Report the current WAL insert location (same format as pg_start_backup etc)
 *
 * This function is mostly for debugging purposes.
 */
Datum
pg_current_xlog_insert_location(PG_FUNCTION_ARGS)
{
	XLogRecPtr	current_recptr;

	if (RecoveryInProgress())
		ereport(ERROR,
				(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
				 errmsg("recovery is in progress"),
				 errhint("WAL control functions cannot be executed during recovery.")));

	current_recptr = GetXLogInsertRecPtr();

	PG_RETURN_LSN(current_recptr);
}

/*
 * Report the current WAL flush location (same format as pg_start_backup etc)
 *
 * This function is mostly for debugging purposes.
 */
Datum
pg_current_xlog_flush_location(PG_FUNCTION_ARGS)
{
	XLogRecPtr	current_recptr;

	if (RecoveryInProgress())
		ereport(ERROR,
				(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
				 errmsg("recovery is in progress"),
				 errhint("WAL control functions cannot be executed during recovery.")));

	current_recptr = GetFlushRecPtr();

	PG_RETURN_LSN(current_recptr);
}

/*
 * Report the last WAL receive location (same format as pg_start_backup etc)
 *
 * This is useful for determining how much of WAL is guaranteed to be received
 * and synced to disk by walreceiver.
 */
Datum
pg_last_xlog_receive_location(PG_FUNCTION_ARGS)
{
	XLogRecPtr	recptr;

	recptr = GetWalRcvWriteRecPtr(NULL, NULL);

	if (recptr == 0)
		PG_RETURN_NULL();

	PG_RETURN_LSN(recptr);
}

/*
 * Report the last WAL replay location (same format as pg_start_backup etc)
 *
 * This is useful for determining how much of WAL is visible to read-only
 * connections during recovery.
 */
Datum
pg_last_xlog_replay_location(PG_FUNCTION_ARGS)
{
	XLogRecPtr	recptr;

	recptr = GetXLogReplayRecPtr(NULL);

	if (recptr == 0)
		PG_RETURN_NULL();

	PG_RETURN_LSN(recptr);
}

/*
 * Compute an xlog file name and decimal byte offset given a WAL location,
 * such as is returned by pg_stop_backup() or pg_xlog_switch().
 *
 * Note that a location exactly at a segment boundary is taken to be in
 * the previous segment.  This is usually the right thing, since the
 * expected usage is to determine which xlog file(s) are ready to archive.
 */
Datum
pg_xlogfile_name_offset(PG_FUNCTION_ARGS)
{
	XLogSegNo	xlogsegno;
	uint32		xrecoff;
	XLogRecPtr	locationpoint = PG_GETARG_LSN(0);
	char		xlogfilename[MAXFNAMELEN];
	Datum		values[2];
	bool		isnull[2];
	TupleDesc	resultTupleDesc;
	HeapTuple	resultHeapTuple;
	Datum		result;

	if (RecoveryInProgress())
		ereport(ERROR,
				(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
				 errmsg("recovery is in progress"),
				 errhint("pg_xlogfile_name_offset() cannot be executed during recovery.")));

	/*
	 * Construct a tuple descriptor for the result row.  This must match this
	 * function's pg_proc entry!
	 */
	resultTupleDesc = CreateTemplateTupleDesc(2, false);
	TupleDescInitEntry(resultTupleDesc, (AttrNumber) 1, "file_name",
					   TEXTOID, -1, 0);
	TupleDescInitEntry(resultTupleDesc, (AttrNumber) 2, "file_offset",
					   INT4OID, -1, 0);

	resultTupleDesc = BlessTupleDesc(resultTupleDesc);

	/*
	 * xlogfilename
	 */
	XLByteToPrevSeg(locationpoint, xlogsegno);
	XLogFileName(xlogfilename, ThisTimeLineID, xlogsegno);

	values[0] = CStringGetTextDatum(xlogfilename);
	isnull[0] = false;

	/*
	 * offset
	 */
	xrecoff = locationpoint % XLogSegSize;

	values[1] = UInt32GetDatum(xrecoff);
	isnull[1] = false;

	/*
	 * Tuple jam: Having first prepared your Datums, then squash together
	 */
	resultHeapTuple = heap_form_tuple(resultTupleDesc, values, isnull);

	result = HeapTupleGetDatum(resultHeapTuple);

	PG_RETURN_DATUM(result);
}

/*
 * Compute an xlog file name given a WAL location,
 * such as is returned by pg_stop_backup() or pg_xlog_switch().
 */
Datum
pg_xlogfile_name(PG_FUNCTION_ARGS)
{
	XLogSegNo	xlogsegno;
	XLogRecPtr	locationpoint = PG_GETARG_LSN(0);
	char		xlogfilename[MAXFNAMELEN];

	if (RecoveryInProgress())
		ereport(ERROR,
				(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
				 errmsg("recovery is in progress"),
		 errhint("pg_xlogfile_name() cannot be executed during recovery.")));

	XLByteToPrevSeg(locationpoint, xlogsegno);
	XLogFileName(xlogfilename, ThisTimeLineID, xlogsegno);

	PG_RETURN_TEXT_P(cstring_to_text(xlogfilename));
}

/*
 * pg_xlog_replay_pause - pause recovery now
 *
 * Permission checking for this function is managed through the normal
 * GRANT system.
 */
Datum
pg_xlog_replay_pause(PG_FUNCTION_ARGS)
{
	if (!RecoveryInProgress())
		ereport(ERROR,
				(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
				 errmsg("recovery is not in progress"),
				 errhint("Recovery control functions can only be executed during recovery.")));

	SetRecoveryPause(true);

	PG_RETURN_VOID();
}

/*
 * pg_xlog_replay_resume - resume recovery now
 *
 * Permission checking for this function is managed through the normal
 * GRANT system.
 */
Datum
pg_xlog_replay_resume(PG_FUNCTION_ARGS)
{
	if (!RecoveryInProgress())
		ereport(ERROR,
				(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
				 errmsg("recovery is not in progress"),
				 errhint("Recovery control functions can only be executed during recovery.")));

	SetRecoveryPause(false);

	PG_RETURN_VOID();
}

/*
 * pg_is_xlog_replay_paused
 */
Datum
pg_is_xlog_replay_paused(PG_FUNCTION_ARGS)
{
	if (!RecoveryInProgress())
		ereport(ERROR,
				(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
				 errmsg("recovery is not in progress"),
				 errhint("Recovery control functions can only be executed during recovery.")));

	PG_RETURN_BOOL(RecoveryIsPaused());
}

/*
 * Returns timestamp of latest processed commit/abort record.
 *
 * When the server has been started normally without recovery the function
 * returns NULL.
 */
Datum
pg_last_xact_replay_timestamp(PG_FUNCTION_ARGS)
{
	TimestampTz xtime;

	xtime = GetLatestXTime();
	if (xtime == 0)
		PG_RETURN_NULL();

	PG_RETURN_TIMESTAMPTZ(xtime);
}

/*
 * Returns bool with current recovery mode, a global state.
 */
Datum
pg_is_in_recovery(PG_FUNCTION_ARGS)
{
	PG_RETURN_BOOL(RecoveryInProgress());
}

/*
 * Compute the difference in bytes between two WAL locations.
 */
Datum
pg_xlog_location_diff(PG_FUNCTION_ARGS)
{
	Datum		result;

	result = DirectFunctionCall2(pg_lsn_mi,
								 PG_GETARG_DATUM(0),
								 PG_GETARG_DATUM(1));

	PG_RETURN_NUMERIC(result);
}

/*
 * Returns bool with current on-line backup mode, a global state.
 */
Datum
pg_is_in_backup(PG_FUNCTION_ARGS)
{
	PG_RETURN_BOOL(BackupInProgress());
}

/*
 * Returns start time of an online exclusive backup.
 *
 * When there's no exclusive backup in progress, the function
 * returns NULL.
 */
Datum
pg_backup_start_time(PG_FUNCTION_ARGS)
{
	Datum		xtime;
	FILE	   *lfp;
	char		fline[MAXPGPATH];
	char		backup_start_time[30];

	/*
	 * See if label file is present
	 */
	lfp = AllocateFile(BACKUP_LABEL_FILE, "r");
	if (lfp == NULL)
	{
		if (errno != ENOENT)
			ereport(ERROR,
					(errcode_for_file_access(),
					 errmsg("could not read file \"%s\": %m",
							BACKUP_LABEL_FILE)));
		PG_RETURN_NULL();
	}

	/*
	 * Parse the file to find the START TIME line.
	 */
	backup_start_time[0] = '\0';
	while (fgets(fline, sizeof(fline), lfp) != NULL)
	{
		if (sscanf(fline, "START TIME: %25[^\n]\n", backup_start_time) == 1)
			break;
	}

	/* Check for a read error. */
	if (ferror(lfp))
		ereport(ERROR,
				(errcode_for_file_access(),
			   errmsg("could not read file \"%s\": %m", BACKUP_LABEL_FILE)));

	/* Close the backup label file. */
	if (FreeFile(lfp))
		ereport(ERROR,
				(errcode_for_file_access(),
			  errmsg("could not close file \"%s\": %m", BACKUP_LABEL_FILE)));

	if (strlen(backup_start_time) == 0)
		ereport(ERROR,
				(errcode(ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE),
				 errmsg("invalid data in file \"%s\"", BACKUP_LABEL_FILE)));

	/*
	 * Convert the time string read from file to TimestampTz form.
	 */
	xtime = DirectFunctionCall3(timestamptz_in,
								CStringGetDatum(backup_start_time),
								ObjectIdGetDatum(InvalidOid),
								Int32GetDatum(-1));

	PG_RETURN_DATUM(xtime);
}
