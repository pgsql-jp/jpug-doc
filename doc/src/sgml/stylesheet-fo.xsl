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
<xsl:param name="hyphenate">false</xsl:param>

<!-- <xsl:param name="title.color">#EC5800</xsl:param> -->
<xsl:param name="title.color">black</xsl:param>

<!-- header settings -->
<xsl:param name="header.column.widths">2 5 2</xsl:param>

<xsl:attribute-set name="component.title.properties">
  <xsl:attribute name="line-height">30pt</xsl:attribute>
  <xsl:attribute name="color"><xsl:value-of select="$title.color"/></xsl:attribute>
  <xsl:attribute name="space-after.minimum">0.5em</xsl:attribute>
  <xsl:attribute name="space-after.optimum">0.5em</xsl:attribute>
  <xsl:attribute name="space-after.maximum">0.5em</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.properties">
  <xsl:attribute name="line-height">30pt</xsl:attribute>
  <xsl:attribute name="color"><xsl:value-of select="$title.color"/></xsl:attribute>
  <xsl:attribute name="space-before.minimum">0.5em</xsl:attribute>
  <xsl:attribute name="space-before.optimum">1.2em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">1.4em</xsl:attribute>
  <xsl:attribute name="space-after.minimum">0.1em</xsl:attribute>
  <xsl:attribute name="space-after.optimum">0.1em</xsl:attribute>
  <xsl:attribute name="space-after.maximum">0.1em</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level1.properties">
  <xsl:attribute name="space-before.minimum">1.0em</xsl:attribute>
  <xsl:attribute name="space-before.optimum">1.2em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">1.4em</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="part.titlepage.recto.style">
  <xsl:attribute name="line-height">30pt</xsl:attribute>
  <xsl:attribute name="color"><xsl:value-of select="$title.color"/></xsl:attribute>
  <xsl:attribute name="space-after.minimum">1.0em</xsl:attribute>
  <xsl:attribute name="space-after.optimum">1.0em</xsl:attribute>
  <xsl:attribute name="space-after.maximum">1.0em</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="reference.titlepage.recto.style">
  <xsl:attribute name="line-height">30pt</xsl:attribute>
  <xsl:attribute name="color"><xsl:value-of select="$title.color"/></xsl:attribute>
  <xsl:attribute name="space-before.minimum">1.0em</xsl:attribute>
  <xsl:attribute name="space-before.optimum">1.0em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">1.0em</xsl:attribute>
  <xsl:attribute name="space-after.minimum">0.1em</xsl:attribute>
  <xsl:attribute name="space-after.optimum">0.1em</xsl:attribute>
  <xsl:attribute name="space-after.maximum">0.1em</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="normal.para.spacing">
  <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
  <xsl:attribute name="space-before.optimum">0.6em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">0.8em</xsl:attribute>
  <xsl:attribute name="text-align">left</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="monospace.verbatim.properties"
                   use-attribute-sets="verbatim.properties monospace.properties">
  <xsl:attribute name="wrap-option">wrap</xsl:attribute>
  <xsl:attribute name="font-size">90%</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="lit.shading.style">
  <xsl:attribute name="background-color">#eef8e8</xsl:attribute>
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

<!-- Change display of some elements -->

<xsl:param name="l10n.gentext.default.language">ja</xsl:param>
<xsl:param name="body.start.indent">0</xsl:param>
<xsl:param name="line-height">150%</xsl:param>

<xsl:param name="title.font.family" select="'YuGothic,Meiryo,MS-PGothic,Hiragino Kaku Gothic ProN,Gen Shin Gothic P,TakaoPGothic'"/>
<xsl:param name="body.font.family" select="'YuMincho,Meiryo,MS-PMincho,Hiragino Mincho ProN,Serif,Gen Shin Gothic P,TakaoPMincho'"/>
<xsl:param name="monospace.font.family" select="'Osaka-mono,MS-Gothic,Gen Shin Gothic Monospace,TakaoGothic'"/>
<xsl:param name="symbol.font.family" select="'Osaka-mono,MS-Gothic,Gen Shin Gothic P,TakaoPGothic'"/>
<xsl:param name="dingbat.font.family" select="'YuGothic,Meiryo,MS-PGothic,Hiragino Kaku Gothic ProN,Gen Shin Gothic P,TakaoPGothic'"/>

<xsl:attribute-set name="table.properties" use-attribute-sets="normal.para.spacing">
  <xsl:attribute name="font-size">80%</xsl:attribute>
  <xsl:attribute name="wrap-option">wrap</xsl:attribute>
  <xsl:attribute name="text-align">left</xsl:attribute>
  <xsl:attribute name="white-space-treatment">ignore</xsl:attribute>
</xsl:attribute-set>

<xsl:template name="table.row.properties">
  <xsl:if test="ancestor::thead">
    <xsl:attribute name="font-size">100%</xsl:attribute>
    <xsl:attribute name="background-color">#EFEFEF</xsl:attribute>
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

<xsl:template match="text()">
<xsl:choose>
  <xsl:when test="ancestor::table">
    <xsl:call-template name="intersperse-with-zero-spaces">
      <xsl:with-param name="str" select="translate(., '&#x2014;', '&#x2015;')"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="translate(., '&#x2014;', '&#x2015;')"/>
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

</xsl:stylesheet>
