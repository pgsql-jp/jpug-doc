# src/bin/pg_basebackup/nls.mk
CATALOG_NAME     = pg_basebackup
<<<<<<< HEAD
AVAIL_LANGUAGES  = cs de es fr he it ja ko pl ru sv tr
=======
AVAIL_LANGUAGES  = cs de es fr he it ja ko pl ru sv tr vi
>>>>>>> REL_11_0
GETTEXT_FILES    = pg_basebackup.c pg_receivewal.c pg_recvlogical.c receivelog.c streamutil.c walmethods.c ../../common/fe_memutils.c ../../common/file_utils.c
GETTEXT_TRIGGERS = simple_prompt tar_set_error
