# src/interfaces/ecpg/preproc/nls.mk
CATALOG_NAME     = ecpg
<<<<<<< HEAD
AVAIL_LANGUAGES  = cs de es fr it ja ko pl pt_BR ru sv tr zh_CN zh_TW
=======
AVAIL_LANGUAGES  = cs de es fr it ja ko pl pt_BR ru sv tr vi zh_CN zh_TW
>>>>>>> REL_11_0
GETTEXT_FILES    = descriptor.c ecpg.c pgc.c preproc.c type.c variable.c
GETTEXT_TRIGGERS = mmerror:3 mmfatal:2
GETTEXT_FLAGS    = mmerror:3:c-format mmfatal:2:c-format
