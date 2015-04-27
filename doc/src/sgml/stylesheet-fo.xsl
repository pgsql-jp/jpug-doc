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

<xsl:param name="title.font.family" select="'YuGothic,Meiryo,MS-PGothic,Hiragino Kaku Gothic ProN,TakaoExGothic,OpenSymbol'"/>
<xsl:param name="body.font.family" select="'YuMincho,Meiryo,MS-PMincho,Hiragino Mincho ProN,TakaoExMincho,Serif'"/>
<xsl:param name="monospace.font.family" select="'Osaka-mono,MS-Gothic,TakaoGothic,monospace,Courier'"/>
<xsl:param name="body.start.indent">0</xsl:param>

<xsl:attribute-set name="monospace.verbatim.properties"
                   use-attribute-sets="verbatim.properties monospace.properties">
  <xsl:attribute name="wrap-option">wrap</xsl:attribute>
</xsl:attribute-set>

<!-- Change display of some elements -->

<xsl:template match="command">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

</xsl:stylesheet>
