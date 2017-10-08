<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

<xsl:param name="local.l10n.xml" select="document('')"/>
<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n language="ja">
    <l:gentext key="nav-prev" text="前へ"/>
    <l:gentext key="nav-up" text="上へ"/>
    <l:context name="xref-number-and-title">
      <l:template name="sect1" text="%n. %t"/>
      <l:template name="sect2" text="%n. %t"/>
      <l:template name="sect3" text="%n. %t"/>
      <l:template name="sect4" text="%n. %t"/>
      <l:template name="sect5" text="%n. %t"/>
    </l:context>
  </l:l10n>
</l:i18n>

<xsl:param name="html.original" select="0"/>

<!--
<xsl:template name="user.head.content">
  <meta name="viewport" content="width=device-width,initial-scale=1.0" />
</xsl:template>
-->

<xsl:template match="comment()">
  <xsl:choose>
    <xsl:when test="$html.original = 1">
      <span class="original" >
        <xsl:value-of select="." />
      </span>
    </xsl:when>
    <xsl:otherwise>
      <xsl:comment><xsl:value-of select="." /></xsl:comment>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
<xsl:template name="section.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>

  <xsl:call-template name="make.toc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
    <xsl:with-param name="nodes"
                    select="refentry
                           |bridgehead[$bridgehead.in.toc != 0]"/>

  </xsl:call-template>
</xsl:template>
-->

<xsl:template match="sect1" mode="toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:call-template name="subtoc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="nodes" select="sect2|refentry                                 |bridgehead[$bridgehead.in.toc != 0]"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
