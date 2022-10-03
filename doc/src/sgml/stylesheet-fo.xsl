<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
                xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/>
<xsl:include href="stylesheet-common.xsl" />

<xsl:param name="fop1.extensions" select="1"></xsl:param>
<xsl:param name="tablecolumns.extension" select="0"></xsl:param>
<xsl:param name="toc.max.depth">3</xsl:param>
<xsl:param name="ulink.footnotes" select="1"></xsl:param>
<xsl:param name="use.extensions" select="1"></xsl:param>
<xsl:param name="variablelist.as.blocks" select="1"></xsl:param>
<xsl:param name="orderedlist.label.width">1.5em</xsl:param>

<xsl:attribute-set name="monospace.verbatim.properties"
                   use-attribute-sets="verbatim.properties monospace.properties">
  <xsl:attribute name="wrap-option">wrap</xsl:attribute>
  <xsl:attribute name="font-size">90%</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="nongraphical.admonition.properties">
  <xsl:attribute name="border-style">solid</xsl:attribute>
  <xsl:attribute name="border-width">1pt</xsl:attribute>
  <xsl:attribute name="border-color">black</xsl:attribute>
  <xsl:attribute name="padding-start">12pt</xsl:attribute>
  <xsl:attribute name="padding-end">12pt</xsl:attribute>
  <xsl:attribute name="padding-top">6pt</xsl:attribute>
  <xsl:attribute name="padding-bottom">6pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="admonition.title.properties">
  <xsl:attribute name="text-align">center</xsl:attribute>
</xsl:attribute-set>

<!-- Make all tables default to left alignment, for consistency with HTML -->
<xsl:attribute-set name="table.table.properties">
  <xsl:attribute name="text-align">left</xsl:attribute>
</xsl:attribute-set>

<!-- fix missing space after vertical simplelist
     https://github.com/docbook/xslt10-stylesheets/issues/31 -->
<xsl:attribute-set name="normal.para.spacing">
  <xsl:attribute name="space-after.optimum">1em</xsl:attribute>
  <xsl:attribute name="space-after.minimum">0.8em</xsl:attribute>
  <xsl:attribute name="space-after.maximum">1.2em</xsl:attribute>
</xsl:attribute-set>

<!-- Change display of some elements -->

<xsl:template match="command">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="confgroup" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates select="conftitle/text()" mode="bibliography.mode"/>
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="confdates/text()" mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="isbn" mode="bibliography.mode">
  <fo:inline>
    <xsl:text>ISBN </xsl:text>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<!-- formatting for entries in tables of functions -->
<xsl:template match="entry[@role='func_table_entry']/para">
  <fo:block margin-left="4em" text-align="left">
    <xsl:if test="self::para[@role='func_signature']">
      <xsl:attribute name="text-indent">-3.5em</xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!-- formatting for entries in tables of catalog/view columns -->
<xsl:template match="entry[@role='catalog_table_entry']/para">
  <fo:block margin-left="4em" text-align="left">
    <xsl:if test="self::para[@role='column_definition']">
      <xsl:attribute name="text-indent">-3.5em</xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!-- overrides stylesheet-common.xsl -->
<!-- FOP needs us to be explicit about the font to use for right arrow -->
<xsl:template match="returnvalue">
  <fo:inline font-family="{$symbol.font.family}">&#x2192; </fo:inline>
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<!-- FOP needs us to be explicit about use of symbol font in some cases -->
<xsl:template match="phrase[@role='symbol_font']">
  <fo:inline font-family="{$symbol.font.family}"><xsl:value-of select="."/></fo:inline>
</xsl:template>

<!-- bug fix from <https://sourceforge.net/p/docbook/bugs/1360/#831b> -->

<xsl:template match="varlistentry/term" mode="xref-to">
  <xsl:param name="verbose" select="1"/>
  <xsl:apply-templates mode="no.anchor.mode"/>
</xsl:template>

<!-- include refsects in PDF bookmarks
     (https://github.com/docbook/xslt10-stylesheets/issues/46) -->

<xsl:template match="refsect1|refsect2|refsect3"
              mode="bookmark">

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <xsl:variable name="bookmark-label">
    <xsl:apply-templates select="." mode="object.title.markup"/>
  </xsl:variable>

  <fo:bookmark internal-destination="{$id}">
    <xsl:attribute name="starting-state">
      <xsl:value-of select="$bookmarks.state"/>
    </xsl:attribute>
    <fo:bookmark-title>
      <xsl:value-of select="normalize-space($bookmark-label)"/>
    </fo:bookmark-title>
    <xsl:apply-templates select="*" mode="bookmark"/>
  </fo:bookmark>
</xsl:template>

<!-- Setting for jpug-doc -->
<xsl:param name="l10n.gentext.default.language">ja</xsl:param>
<xsl:param name="alignment">left</xsl:param>
<xsl:param name="body.start.indent">0</xsl:param>
<xsl:param name="line-height">150%</xsl:param>
<xsl:param name="hyphenate">false</xsl:param>

<xsl:param name="title.font.family" select="'YuGothic,Meiryo,MS-PGothic,Hiragino Kaku Gothic ProN,Gen Shin Gothic P,TakaoPGothic'"/>
<xsl:param name="body.font.family" select="'YuMincho,Meiryo,MS-PMincho,Hiragino Mincho ProN,Serif,Gen Shin Gothic P,TakaoPMincho'"/>
<xsl:param name="monospace.font.family" select="'Osaka-mono,MS-Gothic,Gen Shin Gothic Monospace,TakaoGothic'"/>
<xsl:param name="symbol.font.family" select="'Osaka-mono,MS-Gothic,Gen Shin Gothic P,TakaoPGothic'"/>
<xsl:param name="dingbat.font.family" select="'YuGothic,Meiryo,MS-PGothic,Hiragino Kaku Gothic ProN,Gen Shin Gothic P,TakaoPGothic'"/>

<!-- crop margin -->
<!--
<xsl:param name="page.margin.top">0.1in</xsl:param>
<xsl:param name="page.margin.bottom">0.1in</xsl:param>
<xsl:param name="page.margin.inner">0.1in</xsl:param>
<xsl:param name="page.margin.outer">0.1in</xsl:param>
-->

<!-- <xsl:param name="title.color">#EC5800</xsl:param> -->
<xsl:param name="title.color">black</xsl:param>
<xsl:attribute-set name="component.title.properties">
  <xsl:attribute name="line-height">30pt</xsl:attribute>
  <xsl:attribute name="color"><xsl:value-of select="$title.color"/></xsl:attribute>
  <xsl:attribute name="space-before.minimum">1.5em</xsl:attribute>
  <xsl:attribute name="space-before.optimum">1.5em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">3.0em</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.properties">
  <xsl:attribute name="line-height">30pt</xsl:attribute>
  <xsl:attribute name="color"><xsl:value-of select="$title.color"/></xsl:attribute>
  <xsl:attribute name="space-before.minimum">0.5em</xsl:attribute>
  <xsl:attribute name="space-before.optimum">1.5em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">3.0em</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level1.properties">
  <xsl:attribute name="space-before.minimum">1.0em</xsl:attribute>
  <xsl:attribute name="space-before.optimum">1.2em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">1.4em</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="part.titlepage.recto.style">
  <xsl:attribute name="line-height">30pt</xsl:attribute>
  <xsl:attribute name="color"><xsl:value-of select="$title.color"/></xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="reference.titlepage.recto.style">
  <xsl:attribute name="line-height">30pt</xsl:attribute>
  <xsl:attribute name="color"><xsl:value-of select="$title.color"/></xsl:attribute>
  <xsl:attribute name="space-before.minimum">1.0em</xsl:attribute>
  <xsl:attribute name="space-before.optimum">1.0em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">1.0em</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="table.properties" use-attribute-sets="normal.para.spacing">
  <xsl:attribute name="font-size">80%</xsl:attribute>
</xsl:attribute-set>
<xsl:param name="table.cell.border.color">#999999</xsl:param>

<xsl:template name="table.row.properties">
  <xsl:variable name="rownum">
    <xsl:number from="tgroup" count="row"/>
  </xsl:variable>
  <xsl:if test="ancestor::thead">
    <xsl:attribute name="font-size">100%</xsl:attribute>
    <xsl:attribute name="background-color">#a7c6df</xsl:attribute>
  </xsl:if>
  <xsl:if test="$rownum mod 2 = 0">
    <xsl:attribute name="background-color">#F4F4F4</xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:param name="shade.verbatim">1</xsl:param>
<xsl:attribute-set name="shade.verbatim.style">
  <xsl:attribute name="border">1pt solid black</xsl:attribute>
  <xsl:attribute name="margin-left">0</xsl:attribute>
  <xsl:attribute name="margin-right">0</xsl:attribute>
  <xsl:attribute name="padding">5pt</xsl:attribute>
  <xsl:attribute name="background-color">#EFEFEF</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="xref.properties">
  <xsl:attribute name="color">blue</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="simple.xlink.properties">
  <xsl:attribute name="color">blue</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="index.entry.properties">
  <xsl:attribute name="background-color">#EFEFEF</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="text()">
  <xsl:choose>
    <xsl:when test="ancestor::table">
      <xsl:call-template name="intersperse-with-zero-spaces">
        <xsl:with-param name="str" select="."/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="ideographic-comma">
        <xsl:with-param name="str" select="."/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Actual intercalation: recursive -->
<xsl:template name="intersperse-with-zero-spaces">
  <xsl:param name="str"/>
  <xsl:variable name="spacechars">
    &#x9;&#xA;
    &#x2000;&#x2001;&#x2002;&#x2003;&#x2004;&#x2005;
    &#x2006;&#x2007;&#x2008;&#x2009;&#x200A;&#x200B;
  </xsl:variable>
  <xsl:if test="string-length($str) > 0">
    <xsl:variable name="c1"
                  select="substring($str, 1, 1)"/>
    <xsl:variable name="c2"
                  select="substring($str, 2, 1)"/>
    <xsl:value-of select="$c1"/>
    <xsl:if test="$c2 != '' and
                  not(contains($spacechars, $c1) or
                  contains($spacechars, $c2))">
      <xsl:text>​</xsl:text>
    </xsl:if>
    <xsl:call-template name="intersperse-with-zero-spaces">
      <xsl:with-param name="str" select="substring($str, 2)"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="ideographic-comma">
  <xsl:param name="str"/>
  <xsl:choose>
    <xsl:when test="contains($str, '&#x3001;')">
      <xsl:value-of select="substring-before($str, '&#x3001;')" />&#x3001;&#x200B;
      <xsl:call-template name="ideographic-comma">
        <xsl:with-param name="str" select="substring-after($str, '&#x3001;')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$str" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Remove the first and last extra line breaks in programlisting etc -->
<xsl:template match="node()[parent::programlisting|parent::screen|parent::literallayout|parent::synopsis][1][self::text()][following-sibling::node()]">
  <xsl:call-template name="trim-left">
    <xsl:with-param name="contents" select="."/>
  </xsl:call-template>
</xsl:template>
<xsl:template match="node()[parent::programlisting|parent::screen|parent::literallayout|parent::synopsis][position() = last()][self::text()][preceding-sibling::node()]">
  <xsl:call-template name="trim-right">
    <xsl:with-param name="contents" select="."/>
  </xsl:call-template>
</xsl:template>
<xsl:template match="node()[parent::programlisting|parent::screen|parent::literallayout|parent::synopsis][position() = 1 and position() = last()][self::text()]" priority="1">
  <xsl:call-template name="trim.text">
    <xsl:with-param name="contents" select="."/>
  </xsl:call-template>
</xsl:template>

<!-- header settings -->
<xsl:param name="header.column.widths">2 5 2</xsl:param>
<xsl:template name="header.content">
  <xsl:param name="position" select="''"/>
  <xsl:choose>
<!-- Book Title -->
<!--
    <xsl:when test="$position='left'">
      <xsl:variable name="home" select="/*[1]"/>
      <xsl:apply-templates select="$home" mode="object.title.markup"/>
    </xsl:when>
-->
<!-- Chapter title -->
   <xsl:when test="$position='center'">
      <xsl:apply-templates select="." mode="object.title.markup"/>
    </xsl:when>
<!-- Logo image -->
<!--
    <xsl:when test="$position='right'">
      <fo:external-graphic src="PgKameAoiSen.svg" display-align="before" scaling="uniform" content-height="8%" content-width="8%"/>
      </xsl:when>
-->
  </xsl:choose>
</xsl:template>

<!-- footer settings -->
<xsl:param name="footer.column.widths">5 1 5</xsl:param>
<xsl:template name="footer.content">
  <xsl:param name="position" select="''"/>
  <xsl:choose>
<!-- Book title -->
<!--
    <xsl:when test="$position='left'">
      <xsl:attribute name="font-size">9pt</xsl:attribute>
      <xsl:variable name="home" select="/*[1]"/>
      <xsl:apply-templates select="$home" mode="object.title.markup"/>
    </xsl:when>
-->
<!-- Page Number -->
    <xsl:when test="$position='center'">
      <fo:page-number/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
