#----------------------------------------------------------------------------
#
# PostgreSQL documentation makefile
#
# doc/src/sgml/Makefile
#
#----------------------------------------------------------------------------

# This makefile is for building and installing the documentation.
# When a release tarball is created, the documentation files are
# prepared using the distprep target.  In Git-based trees these files
# don't exist, unless explicitly built, so we skip the installation in
# that case.


# Make "html" the default target, since that is what most people tend
# to want to use.
html:

NO_TEMP_INSTALL=yes

subdir = doc/src/sgml
top_builddir = ../../..
include $(top_builddir)/src/Makefile.global


all: html man

distprep: html distprep-man


ifndef DBTOEPUB
DBTOEPUB = $(missing) dbtoepub
endif

ifndef FOP
FOP = $(missing) fop
endif

SGMLINCLUDE = -D . -D $(srcdir)

ifndef NSGMLS
NSGMLS = $(missing) nsgmls
endif

ifndef OSX
OSX = $(missing) osx
endif

ifndef XMLLINT
XMLLINT = $(missing) xmllint
endif

ifndef XSLTPROC
XSLTPROC = $(missing) xsltproc
endif

ifndef FOPCONF
FOPCONF = fop.xconf
endif

override XSLTPROCFLAGS += --stringparam pg.version '$(VERSION)'


GENERATED_SGML = version.sgml \
	features-supported.sgml features-unsupported.sgml errcodes-table.sgml

ALLSGML := $(wildcard $(srcdir)/*.sgml $(srcdir)/ref/*.sgml) $(GENERATED_SGML)

# Enable some extra warnings
# -wfully-tagged needed to throw a warning on missing tags
# for older tool chains, 2007-08-31
# Note: try "make SPFLAGS=-wxml" to catch a lot of other dubious constructs,
# in particular < and & that haven't been made into entities.  It's far too
# noisy to turn on by default, unfortunately.
override SPFLAGS += -wall -wno-unused-param -wno-empty -wfully-tagged


##
## Man pages
##

man distprep-man: man-stamp

man-stamp: stylesheet-man.xsl postgres.xml
	$(XMLLINT) --noout --valid postgres.xml
	$(XSLTPROC) $(XSLTPROCFLAGS) $(XSLTPROC_MAN_FLAGS) $^
	touch $@


##
## common files
##

<<<<<<< HEAD
.PHONY: draft

JADE.html.call = SP_CHARSET_FIXED=1 SP_ENCODING=UTF-8 $(JADE) $(JADEFLAGS) $(SPFLAGS) $(SGMLINCLUDE) $(CATALOG) -d stylesheet.dsl -t sgml -i output-html
ifeq ($(STYLE),website)
JADE.html.call += -V website-stylesheet
endif

# The draft target creates HTML output in draft mode, without index (for faster build).
draft: postgres.sgml $(ALMOSTALLSGML) stylesheet.dsl
	$(MKDIR_P) html
	$(JADE.html.call) -V draft-mode $<
	cp $(srcdir)/stylesheet.css html/

html: html-stamp

html-stamp: postgres.sgml $(ALLSGML) stylesheet.dsl
	$(MAKE) check-tabs
	$(MKDIR_P) html
	$(JADE.html.call) -i include-index $<
	cp $(srcdir)/stylesheet.css html/
	touch $@

# single-page HTML
postgres.html: postgres.sgml $(ALLSGML) stylesheet.dsl
	$(JADE.html.call) -V nochunks -V rootchunk -V '(define %root-filename% #f)' -V '(define use-output-dir #f)' -i include-index $<

# single-page text
postgres.txt: postgres.html
	$(LYNX) -force_html -dump -nolist $< > $@

HTML.index: postgres.sgml $(ALMOSTALLSGML) stylesheet.dsl
	@$(MKDIR_P) html
	$(JADE.html.call) -V html-index $<

bookindex.sgml: HTML.index
ifdef COLLATEINDEX
	LC_ALL=C $(PERL) $(COLLATEINDEX) -f -g -i 'bookindex' -o $@ $<
else
	@$(missing) collateindex.pl $< $@
endif

=======
>>>>>>> REL_10_0
# Technically, this should depend on Makefile.global, but then
# version.sgml would need to be rebuilt after every configure run,
# even in distribution tarballs.  So this is cheating a bit, but it
# will achieve the goal of updating the version number when it
# changes.
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


##
## Generation of some text files.
##

ICONV = iconv
LYNX = lynx

# The documentation may contain non-ASCII characters (mostly for
# contributor names), which lynx converts to the encoding determined
# by the current locale.  To get text output that is deterministic and
# easily readable by everyone, we make lynx produce LATIN1 and then
# convert that to ASCII with transliteration for the non-ASCII characters.
# Official releases were historically built on FreeBSD, which has limited
# locale support and is very picky about locale name spelling.  The
# below has been finely tuned to run on FreeBSD and Linux/glibc.
INSTALL: % : %.html
<<<<<<< HEAD
	$(PERL) -p -e 's/<H(1|2)$$/<H\1 align=center/g' $< | LC_ALL=ja_JP.UTF-8 $(LYNX) -force_html -dump -nolist -stdin > $@

INSTALL.html: standalone-install.sgml installation.sgml version.sgml
	SP_CHARSET_FIXED=1 SP_ENCODING=UTF-8 $(JADE.text) -V nochunks standalone-install.sgml installation.sgml > $@
=======
	$(PERL) -p -e 's,<h(1|2) class="title",<h\1 align=center,g' $< | LC_ALL=en_US.ISO8859-1 $(LYNX) -force_html -dump -nolist -stdin | $(ICONV) -f latin1 -t us-ascii//TRANSLIT > $@

INSTALL.html: %.html : stylesheet-text.xsl %.xml
	$(XMLLINT) --noout --valid $*.xml
	$(XSLTPROC) $(XSLTPROCFLAGS) $(XSLTPROC_HTML_FLAGS) $^ >$@

INSTALL.xml: standalone-install.sgml installation.sgml version.sgml
	$(OSX) $(SPFLAGS) $(SGMLINCLUDE) -x lower $(filter-out version.sgml,$^) >$@.tmp
	$(call mangle-xml,chapter)
>>>>>>> REL_10_0


##
## SGML->XML conversion
##

# For obscure reasons, GNU make 3.81 complains about circular dependencies
# if we try to do "make all" in a VPATH build without the explicit
# $(srcdir) on the postgres.sgml dependency in this rule.  GNU make bug?
<<<<<<< HEAD
postgres.xml: $(srcdir)/postgres.sgml $(ALMOSTALLSGML)
	SP_CHARSET_FIXED=1 SP_ENCODING=UTF-8 \
	$(OSX) -D. -x comment -x lower -i include-xslt-index $< >postgres.xmltmp
	$(PERL) -p -e 's/\[(aacute|acirc|aelig|agrave|amp|aring|atilde|auml|bull|copy|eacute|egrave|gt|iacute|lt|mdash|nbsp|ntilde|oacute|ocirc|oslash|ouml|pi|quot|scaron|uuml) *\]/\&\1;/gi;' \
                   -e 's/\<!-- doc\/src\/sgml\/.*\.sgml --\>//;' \
	           -e '$$_ .= qq{<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN" "http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd">\n} if $$. == 1;' \
	  <postgres.xmltmp > $@
	rm postgres.xmltmp
# ' hello Emacs
=======
postgres.xml: $(srcdir)/postgres.sgml $(ALLSGML)
	$(OSX) $(SPFLAGS) $(SGMLINCLUDE) -x lower $< >$@.tmp
	$(call mangle-xml,book)

define mangle-xml
$(PERL) -p -e 's/\[(aacute|acirc|aelig|agrave|amp|aring|atilde|auml|bull|copy|eacute|egrave|gt|iacute|lt|mdash|nbsp|ntilde|oacute|ocirc|oslash|ouml|pi|quot|scaron|uuml) *\]/\&\1;/gi;' \
           -e '$$_ .= qq{<!DOCTYPE $(1) PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN" "http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd">\n} if $$. == 1;' \
  <$@.tmp > $@
rm $@.tmp
endef


##
## HTML
##
>>>>>>> REL_10_0

ifeq ($(STYLE),website)
XSLTPROC_HTML_FLAGS += --param website.stylesheet 1
endif

<<<<<<< HEAD
ifdef ORIGINAL
XSLTPROC_HTML_FLAGS += --param html.original 1
endif

xslthtml: xslthtml-stamp
=======
html: html-stamp
>>>>>>> REL_10_0

html-stamp: stylesheet.xsl postgres.xml
	$(XMLLINT) --noout --valid postgres.xml
	$(XSLTPROC) $(XSLTPROCFLAGS) $(XSLTPROC_HTML_FLAGS) $^
	cp $(srcdir)/stylesheet.css html/
	touch $@

htmlhelp: stylesheet-hh.xsl postgres.xml
	$(XMLLINT) --noout --valid postgres.xml
	$(XSLTPROC) $(XSLTPROCFLAGS) $^

<<<<<<< HEAD
=======
# single-page HTML
postgres.html: stylesheet-html-nochunk.xsl postgres.xml
	$(XMLLINT) --noout --valid postgres.xml
	$(XSLTPROC) $(XSLTPROCFLAGS) $(XSLTPROC_HTML_FLAGS) -o $@ $^

# single-page text
postgres.txt: postgres.html
	$(LYNX) -force_html -dump -nolist $< > $@


##
## Print
##

postgres.pdf:
	$(error Invalid target;  use postgres-A4.pdf or postgres-US.pdf as targets)

>>>>>>> REL_10_0
%-A4.fo: stylesheet-fo.xsl %.xml
	$(XMLLINT) --noout --valid $*.xml
	$(XSLTPROC) $(XSLTPROCFLAGS) --stringparam paper.type A4 -o $@ $^

%-US.fo: stylesheet-fo.xsl %.xml
	$(XMLLINT) --noout --valid $*.xml
	$(XSLTPROC) $(XSLTPROCFLAGS) --stringparam paper.type USletter -o $@ $^

%.pdf: %.fo
	$(FOP) -fo $< -pdf $@

<<<<<<< HEAD
.SECONDARY: postgres-A4.fo postgres-US.fo

%-fop.pdf: %.fo
	$(FOP) -c $(FOPCONF) -fo $< -pdf $@
=======

##
## EPUB
##
>>>>>>> REL_10_0

epub: postgres.epub
postgres.epub: postgres.xml
	$(XMLLINT) --noout --valid $<
	$(DBTOEPUB) $<


##
## Experimental Texinfo targets
##

DB2X_TEXIXML = db2x_texixml
DB2X_XSLTPROC = db2x_xsltproc
MAKEINFO = makeinfo

%.texixml: %.xml
	$(DB2X_XSLTPROC) -s texi -g output-file=$(basename $@) $< -o $@

%.texi: %.texixml
	$(DB2X_TEXIXML) --encoding=iso-8859-1//TRANSLIT $< --to-stdout > $@

%.info: %.texi
	$(MAKEINFO) --enable-encoding --no-split --no-validate $< -o $@


##
## Check
##

# Quick syntax check without style processing
<<<<<<< HEAD
check: postgres.sgml $(ALMOSTALLSGML) check-tabs
	SP_CHARSET_FIXED=1 SP_ENCODING=UTF-8 \
=======
check: postgres.sgml $(ALLSGML) check-tabs
>>>>>>> REL_10_0
	$(NSGMLS) $(SPFLAGS) $(SGMLINCLUDE) -s $<


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
	cp -R $(call vpathsearch,html) '$(DESTDIR)$(htmldir)'


## Install man

install-man: man installdirs

sqlmansect ?= 7
sqlmansectnum = $(shell expr X'$(sqlmansect)' : X'\([0-9]\)')

# Before we install the man pages, we massage the section numbers to
# follow the local conventions.
#
ifeq ($(sqlmansectnum),7)
install-man:
	cp -R $(foreach dir,man1 man3 man7,$(call vpathsearch,$(dir))) '$(DESTDIR)$(mandir)'

else # sqlmansectnum != 7
fix_sqlmansectnum = sed -e '/^\.TH/s/"7"/"$(sqlmansect)"/' \
			-e 's/\\fR(7)/\\fR($(sqlmansectnum))/g' \
			-e '1s/^\.so man7/.so man$(sqlmansectnum)/g;1s/^\(\.so.*\)\.7$$/\1.$(sqlmansect)/g'

man: fixed-man-stamp

fixed-man-stamp: man-stamp
	@$(MKDIR_P) $(addprefix fixedman/,man1 man3 man$(sqlmansectnum))
	for file in $(call vpathsearch,man1)/*.1; do $(fix_sqlmansectnum) $$file >fixedman/man1/`basename $$file` || exit; done
	for file in $(call vpathsearch,man3)/*.3; do $(fix_sqlmansectnum) $$file >fixedman/man3/`basename $$file` || exit; done
	for file in $(call vpathsearch,man7)/*.7; do $(fix_sqlmansectnum) $$file >fixedman/man$(sqlmansectnum)/`basename $$file | sed s/\.7$$/.$(sqlmansect)/` || exit; done

install-man:
	cp -R $(foreach dir,man1 man3 man$(sqlmansectnum),fixedman/$(dir)) '$(DESTDIR)$(mandir)'

clean: clean-man
.PHONY: clean-man
clean-man:
	rm -rf fixedman/ fixed-man-stamp

endif # sqlmansectnum != 7

# tabs are harmless, but it is best to avoid them in SGML files
check-tabs:
	@( ! grep '	' $(wildcard $(srcdir)/*.sgml $(srcdir)/ref/*.sgml $(srcdir)/*.dsl $(srcdir)/*.xsl) ) || (echo "Tabs appear in SGML/XML files" 1>&2;  exit 1)

##
## Clean
##

# This allows removing some files from the distribution tarballs while
# keeping the dependencies satisfied.
.SECONDARY: postgres.xml $(GENERATED_SGML) HTML.index
.SECONDARY: INSTALL.html INSTALL.xml
.SECONDARY: postgres-A4.fo postgres-US.fo

clean:
# text --- these are shipped, but not in this directory
	rm -f INSTALL
	rm -f INSTALL.html INSTALL.xml
# single-page output
	rm -f postgres.html postgres.txt
# print
<<<<<<< HEAD
	rm -f *.rtf *.tex-ps *.tex-pdf *.dvi *.aux *.log *.ps *.pdf *.out *.fot
# index
	rm -f HTML.index $(GENERATED_SGML)
# XSLT
	rm -f postgres.xml postgres.xmltmp htmlhelp.hhp toc.hhc index.hhk *.fo
	rm -fr .fontmetrics
=======
	rm -f *.fo *.pdf
# generated SGML files
	rm -f $(GENERATED_SGML)
# SGML->XML conversion
	rm -f postgres.xml *.tmp
# HTML Help
	rm -f htmlhelp.hhp toc.hhc index.hhk
>>>>>>> REL_10_0
# EPUB
	rm -f postgres.epub
# Texinfo
	rm -f *.texixml *.texi *.info db2texi.refs

distclean: clean

maintainer-clean: distclean
# HTML
	rm -fr html/ html-stamp
# man
	rm -rf man1/ man3/ man7/ man-stamp
