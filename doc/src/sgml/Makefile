#----------------------------------------------------------------------------
#
# PostgreSQL documentation makefile
#
# doc/src/sgml/Makefile
#
#----------------------------------------------------------------------------

# This makefile is for building and installing the documentation.
# In Git-based trees these files
# don't exist, unless explicitly built, so we skip the installation in
# that case.


# Make "html" the default target, since that is what most people tend
# to want to use.
html:
# Note that all is *not* the default target in this directory
all: html man

# We don't need the tree-wide headers or install support here.
NO_GENERATED_HEADERS=yes
NO_TEMP_INSTALL=yes

subdir = doc/src/sgml
top_builddir = ../../..
include $(top_builddir)/src/Makefile.global



ifndef DBTOEPUB
DBTOEPUB = $(missing) dbtoepub
endif

ifndef FOP
FOP = $(missing) fop
endif

PANDOC = pandoc

XMLINCLUDE = --path . --path $(srcdir)

ifdef XMLLINT
XMLLINT := $(XMLLINT) --nonet
else
XMLLINT = $(missing) xmllint
endif

ifdef XSLTPROC
XSLTPROC := $(XSLTPROC) --nonet
else
XSLTPROC = $(missing) xsltproc
endif

ifndef FOPCONF
FOPCONF = fop.xconf
endif

override XSLTPROCFLAGS += --stringparam pg.version '$(VERSION)'


GENERATED_SGML = version.sgml \
	features-supported.sgml features-unsupported.sgml errcodes-table.sgml \
	keywords-table.sgml wait_event_types.sgml

ALLSGML := $(wildcard $(srcdir)/*.sgml $(srcdir)/ref/*.sgml) $(GENERATED_SGML)

ALL_IMAGES := $(wildcard $(srcdir)/images/*.svg)


# Run validation only once, common to all subsequent targets.  While
# we're at it, also resolve all entities (that is, copy all included
# files into one big file).  This helps tools that don't understand
# vpath builds (such as dbtoepub).
postgres-full.xml: postgres.sgml $(ALLSGML)
	$(XMLLINT) $(XMLINCLUDE) --output $@ --noent --valid $<


##
## Man pages
##

man: man-stamp

man-stamp: stylesheet-man.xsl postgres-full.xml
	$(XSLTPROC) $(XMLINCLUDE) $(XSLTPROCFLAGS) $(XSLTPROC_MAN_FLAGS) $^
	touch $@


##
## common files
##

# Technically, this should depend on Makefile.global, but then
# version.sgml would need to be rebuilt after every configure run.  So
# this is cheating a bit, but it will achieve the goal of updating the
# version number when it changes.
version.sgml: $(top_srcdir)/configure
	{ \
	  echo "<!ENTITY version \"$(VERSION)\">"; \
	  echo "<!ENTITY majorversion \"$(MAJORVERSION)\">"; \
	} > $@

features-supported.sgml: $(top_srcdir)/src/backend/catalog/sql_feature_packages.txt.ja $(top_srcdir)/src/backend/catalog/sql_features.txt.ja
	$(PERL) $(srcdir)/mk_feature_tables.pl YES $^ > $@

features-unsupported.sgml: $(top_srcdir)/src/backend/catalog/sql_feature_packages.txt.ja $(top_srcdir)/src/backend/catalog/sql_features.txt.ja
	$(PERL) $(srcdir)/mk_feature_tables.pl NO $^ > $@

errcodes-table.sgml: $(top_srcdir)/src/backend/utils/errcodes.txt.ja generate-errcodes-table.pl
	$(PERL) $(srcdir)/generate-errcodes-table.pl $< > $@

keywords-table.sgml: $(top_srcdir)/src/include/parser/kwlist.h $(wildcard $(srcdir)/keywords/sql*.txt) generate-keywords-table.pl
	$(PERL) $(srcdir)/generate-keywords-table.pl $(srcdir) > $@

wait_event_types.sgml: $(top_srcdir)/src/backend/utils/activity/wait_event_names.txt.ja $(top_srcdir)/src/backend/utils/activity/generate-wait_event_types.pl
	$(PERL) $(top_srcdir)/src/backend/utils/activity/generate-wait_event_types.pl --docs $<

targets-meson.sgml.en: targets-meson.txt $(srcdir)/generate-targets-meson.pl
	$(PERL) $(srcdir)/generate-targets-meson.pl $^ > $@


##
## HTML
##

ifeq ($(STYLE),website)
XSLTPROC_HTML_FLAGS += --param website.stylesheet 1
endif

ifdef ORIGINAL
XSLTPROC_HTML_FLAGS += --param html.original 1
endif

html: html-stamp

html-stamp: stylesheet.xsl postgres-full.xml $(ALL_IMAGES)
	$(XSLTPROC) $(XMLINCLUDE) $(XSLTPROCFLAGS) $(XSLTPROC_HTML_FLAGS) $(wordlist 1,2,$^)
	touch $@

# single-page HTML
postgres.html: stylesheet-html-nochunk.xsl postgres-full.xml $(ALL_IMAGES)
	$(XSLTPROC) $(XMLINCLUDE) $(XSLTPROCFLAGS) $(XSLTPROC_HTML_FLAGS) -o $@ $(wordlist 1,2,$^)

# single-page text
postgres.txt: postgres.html
	$(PANDOC) -t plain -o $@ $<


##
## Print
##

postgres.pdf:
	$(error Invalid target;  use postgres-A4.pdf or postgres-US.pdf as targets)

XSLTPROC_FO_FLAGS += --stringparam img.src.path '$(srcdir)/'

%-A4.fo: stylesheet-fo.xsl %-full.xml
	$(XSLTPROC) $(XMLINCLUDE) $(XSLTPROCFLAGS) $(XSLTPROC_FO_FLAGS) --stringparam paper.type A4 -o $@ $^

%-US.fo: stylesheet-fo.xsl %-full.xml
	$(XSLTPROC) $(XMLINCLUDE) $(XSLTPROCFLAGS) $(XSLTPROC_FO_FLAGS) --stringparam paper.type USletter -o $@ $^

%.pdf: %.fo $(ALL_IMAGES)
	$(FOP) -c $(FOPCONF) -fo $< -pdf $@


##
## EPUB
##

epub: postgres.epub
postgres.epub: postgres-full.xml $(ALL_IMAGES)
ifeq ($(vpath_build),yes)
	$(MKDIR_P) images
	cp $(ALL_IMAGES) images/
endif
	$(DBTOEPUB) -o $@ $<


##
## Experimental Texinfo targets
##

DB2X_TEXIXML = db2x_texixml
DB2X_XSLTPROC = db2x_xsltproc
MAKEINFO = makeinfo

%.texixml: %-full.xml
	$(DB2X_XSLTPROC) -s texi -g output-file=$(basename $@) $< -o $@

%.texi: %.texixml
	$(DB2X_TEXIXML) --encoding=utf-8 $< --to-stdout > $@

%.info: %.texi
	$(MAKEINFO) --enable-encoding --no-split --no-validate $< -o $@


##
## Check
##

# Quick syntax check without style processing
check: postgres.sgml $(ALLSGML) check-tabs check-ng
	$(XMLLINT) $(XMLINCLUDE) --noout --valid $<


##
## Install
##

install: install-html install-man

installdirs:
	$(MKDIR_P) '$(DESTDIR)$(htmldir)'/html $(addprefix '$(DESTDIR)$(mandir)'/man, 1 3 $(sqlmansectnum))

# If the install used a man directory shared with other applications, this will remove all files.
uninstall:
	rm -f '$(DESTDIR)$(htmldir)/html/'* $(addprefix  '$(DESTDIR)$(mandir)'/man, 1/* 3/* $(sqlmansectnum)/*)


## Install html

install-html: html installdirs
	cp -R html '$(DESTDIR)$(htmldir)'


## Install man

install-man: man installdirs

sqlmansect ?= 7
sqlmansectnum = $(shell expr X'$(sqlmansect)' : X'\([0-9]\)')

# Before we install the man pages, we massage the section numbers to
# follow the local conventions.
#
ifeq ($(sqlmansectnum),7)
install-man:
	cp -R man1 man3 man7 '$(DESTDIR)$(mandir)'

else # sqlmansectnum != 7
fix_sqlmansectnum = sed -e '/^\.TH/s/"7"/"$(sqlmansect)"/' \
			-e 's/\\fR(7)/\\fR($(sqlmansectnum))/g' \
			-e '1s/^\.so man7/.so man$(sqlmansectnum)/g;1s/^\(\.so.*\)\.7$$/\1.$(sqlmansect)/g'

man: fixed-man-stamp

fixed-man-stamp: man-stamp
	@$(MKDIR_P) $(addprefix fixedman/,man1 man3 man$(sqlmansectnum))
	for file in man1/*.1; do $(fix_sqlmansectnum) $$file >fixedman/man1/`basename $$file` || exit; done
	for file in man3/*.3; do $(fix_sqlmansectnum) $$file >fixedman/man3/`basename $$file` || exit; done
	for file in man7/*.7; do $(fix_sqlmansectnum) $$file >fixedman/man$(sqlmansectnum)/`basename $$file | sed s/\.7$$/.$(sqlmansect)/` || exit; done

install-man:
	cp -R $(foreach dir,man1 man3 man$(sqlmansectnum),fixedman/$(dir)) '$(DESTDIR)$(mandir)'

clean: clean-man
.PHONY: clean-man
clean-man:
	rm -rf fixedman/ fixed-man-stamp

endif # sqlmansectnum != 7

# tabs are harmless, but it is best to avoid them in SGML files
check-tabs:
	@( ! grep '	' $(wildcard $(srcdir)/*.sgml $(srcdir)/ref/*.sgml $(srcdir)/*.xsl) ) || (echo "Tabs appear in SGML/XML files" 1>&2;  exit 1)

# words to avoid as pgsql-jp
check-ng:
	@ln -sf $(top_builddir)/.ng.list .ng.list
	@if git --no-pager grep -E --color=always -f .ng.list *sgml ref/*sgml; \
	then \
	  echo "使用NGな語が見つかりました。";\
	  false;\
	fi

##
## Clean
##

# This allows removing some files from the distribution tarballs while
# keeping the dependencies satisfied.
.SECONDARY: $(GENERATED_SGML)
.SECONDARY: postgres-full.xml
.SECONDARY: postgres-A4.fo postgres-US.fo

clean:
# single-page output
	rm -f postgres.html postgres.txt
# print
	rm -f *.fo *.pdf
# generated SGML files
	rm -f $(GENERATED_SGML)
	rm -f postgres-full.xml
# EPUB
	rm -f postgres.epub
# Texinfo
	rm -f *.texixml *.texi *.info db2texi.refs

distclean: clean
# HTML
	rm -fr html/ html-stamp
# man
	rm -rf man1/ man3/ man7/ man-stamp
