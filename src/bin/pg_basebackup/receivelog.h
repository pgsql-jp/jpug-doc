/*-------------------------------------------------------------------------
 *
 * receivelog.h
 *
 * Portions Copyright (c) 1996-2016, PostgreSQL Global Development Group
 *
 * IDENTIFICATION
 *		  src/bin/pg_basebackup/receivelog.h
 *-------------------------------------------------------------------------
 */

#ifndef RECEIVELOG_H
#define RECEIVELOG_H

#include "libpq-fe.h"

#include "access/xlogdefs.h"

/*
 * Called before trying to read more data or when a segment is
 * finished. Return true to stop streaming.
 */
typedef bool (*stream_stop_callback) (XLogRecPtr segendpos, uint32 timeline, bool segment_finished);

/*
 * Global parameters when receiving xlog stream. For details about the individual fields,
 * see the function comment for ReceiveXlogStream().
 */
typedef struct StreamCtl
{
	XLogRecPtr	startpos;		/* Start position for streaming */
	TimeLineID	timeline;		/* Timeline to stream data from */
	char	   *sysidentifier;	/* Validate this system identifier and
								 * timeline */
	int			standby_message_timeout;		/* Send status messages this
												 * often */
	bool		synchronous;	/* Flush data on write */
	bool		mark_done;		/* Mark segment as done in generated archive */

	stream_stop_callback stream_stop;	/* Stop streaming when returns true */

	char	   *basedir;		/* Received segments written to this dir */
	char	   *partial_suffix; /* Suffix appended to partially received files */
} StreamCtl;



extern bool CheckServerVersionForStreaming(PGconn *conn);
extern bool ReceiveXlogStream(PGconn *conn,
				  StreamCtl *stream);

#endif   /* RECEIVELOG_H */
