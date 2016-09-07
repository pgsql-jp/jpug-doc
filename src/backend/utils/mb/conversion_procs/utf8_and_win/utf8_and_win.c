/*-------------------------------------------------------------------------
 *
 *	  WIN <--> UTF8
 *
 * Portions Copyright (c) 1996-2016, PostgreSQL Global Development Group
 * Portions Copyright (c) 1994, Regents of the University of California
 *
 * IDENTIFICATION
 *	  src/backend/utils/mb/conversion_procs/utf8_and_win/utf8_and_win.c
 *
 *-------------------------------------------------------------------------
 */

#include "postgres.h"
#include "fmgr.h"
#include "mb/pg_wchar.h"
#include "../../Unicode/utf8_to_win1250.map"
#include "../../Unicode/utf8_to_win1251.map"
#include "../../Unicode/utf8_to_win1252.map"
#include "../../Unicode/utf8_to_win1253.map"
#include "../../Unicode/utf8_to_win1254.map"
#include "../../Unicode/utf8_to_win1255.map"
#include "../../Unicode/utf8_to_win1256.map"
#include "../../Unicode/utf8_to_win1257.map"
#include "../../Unicode/utf8_to_win1258.map"
#include "../../Unicode/utf8_to_win866.map"
#include "../../Unicode/utf8_to_win874.map"
#include "../../Unicode/win1250_to_utf8.map"
#include "../../Unicode/win1251_to_utf8.map"
#include "../../Unicode/win1252_to_utf8.map"
#include "../../Unicode/win1253_to_utf8.map"
#include "../../Unicode/win1254_to_utf8.map"
#include "../../Unicode/win1255_to_utf8.map"
#include "../../Unicode/win1256_to_utf8.map"
#include "../../Unicode/win1257_to_utf8.map"
#include "../../Unicode/win866_to_utf8.map"
#include "../../Unicode/win874_to_utf8.map"
#include "../../Unicode/win1258_to_utf8.map"

PG_MODULE_MAGIC;

PG_FUNCTION_INFO_V1(win_to_utf8);
PG_FUNCTION_INFO_V1(utf8_to_win);

/* ----------
 * conv_proc(
 *		INTEGER,	-- source encoding id
 *		INTEGER,	-- destination encoding id
 *		CSTRING,	-- source string (null terminated C string)
 *		CSTRING,	-- destination string (null terminated C string)
 *		INTEGER		-- source string length
 * ) returns VOID;
 * ----------
 */

typedef struct
{
	pg_enc		encoding;
	const pg_local_to_utf *map1;	/* to UTF8 map name */
	const pg_utf_to_local *map2;	/* from UTF8 map name */
	int			size1;			/* size of map1 */
	int			size2;			/* size of map2 */
} pg_conv_map;

static const pg_conv_map maps[] = {
	{PG_WIN866, LUmapWIN866, ULmapWIN866,
		lengthof(LUmapWIN866),
	lengthof(ULmapWIN866)},
	{PG_WIN874, LUmapWIN874, ULmapWIN874,
		lengthof(LUmapWIN874),
	lengthof(ULmapWIN874)},
	{PG_WIN1250, LUmapWIN1250, ULmapWIN1250,
		lengthof(LUmapWIN1250),
	lengthof(ULmapWIN1250)},
	{PG_WIN1251, LUmapWIN1251, ULmapWIN1251,
		lengthof(LUmapWIN1251),
	lengthof(ULmapWIN1251)},
	{PG_WIN1252, LUmapWIN1252, ULmapWIN1252,
		lengthof(LUmapWIN1252),
	lengthof(ULmapWIN1252)},
	{PG_WIN1253, LUmapWIN1253, ULmapWIN1253,
		lengthof(LUmapWIN1253),
	lengthof(ULmapWIN1253)},
	{PG_WIN1254, LUmapWIN1254, ULmapWIN1254,
		lengthof(LUmapWIN1254),
	lengthof(ULmapWIN1254)},
	{PG_WIN1255, LUmapWIN1255, ULmapWIN1255,
		lengthof(LUmapWIN1255),
	lengthof(ULmapWIN1255)},
	{PG_WIN1256, LUmapWIN1256, ULmapWIN1256,
		lengthof(LUmapWIN1256),
	lengthof(ULmapWIN1256)},
	{PG_WIN1257, LUmapWIN1257, ULmapWIN1257,
		lengthof(LUmapWIN1257),
	lengthof(ULmapWIN1257)},
	{PG_WIN1258, LUmapWIN1258, ULmapWIN1258,
		lengthof(LUmapWIN1258),
	lengthof(ULmapWIN1258)},
};

Datum
win_to_utf8(PG_FUNCTION_ARGS)
{
	int			encoding = PG_GETARG_INT32(0);
	unsigned char *src = (unsigned char *) PG_GETARG_CSTRING(2);
	unsigned char *dest = (unsigned char *) PG_GETARG_CSTRING(3);
	int			len = PG_GETARG_INT32(4);
	int			i;

	CHECK_ENCODING_CONVERSION_ARGS(-1, PG_UTF8);

	for (i = 0; i < lengthof(maps); i++)
	{
		if (encoding == maps[i].encoding)
		{
			LocalToUtf(src, len, dest,
					   maps[i].map1, maps[i].size1,
					   NULL, 0,
					   NULL,
					   encoding);
			PG_RETURN_VOID();
		}
	}

	ereport(ERROR,
			(errcode(ERRCODE_INTERNAL_ERROR),
			 errmsg("unexpected encoding ID %d for WIN character sets",
					encoding)));

	PG_RETURN_VOID();
}

Datum
utf8_to_win(PG_FUNCTION_ARGS)
{
	int			encoding = PG_GETARG_INT32(1);
	unsigned char *src = (unsigned char *) PG_GETARG_CSTRING(2);
	unsigned char *dest = (unsigned char *) PG_GETARG_CSTRING(3);
	int			len = PG_GETARG_INT32(4);
	int			i;

	CHECK_ENCODING_CONVERSION_ARGS(PG_UTF8, -1);

	for (i = 0; i < lengthof(maps); i++)
	{
		if (encoding == maps[i].encoding)
		{
			UtfToLocal(src, len, dest,
					   maps[i].map2, maps[i].size2,
					   NULL, 0,
					   NULL,
					   encoding);
			PG_RETURN_VOID();
		}
	}

	ereport(ERROR,
			(errcode(ERRCODE_INTERNAL_ERROR),
			 errmsg("unexpected encoding ID %d for WIN character sets",
					encoding)));

	PG_RETURN_VOID();
}
