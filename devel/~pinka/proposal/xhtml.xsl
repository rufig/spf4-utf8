<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
>

<xsl:include href="../samples/2007/notion/xhtml.xsl"/>

<xsl:template match="def">
  <dl id="word:{@name}" class="def">
    <dt class="w"><xsl:value-of select="@name"/><xsl:if test="@ds"> ( <xsl:value-of select="@ds"/> )</xsl:if></dt>
    <dd><xsl:apply-templates/></dd>
  </dl>
</xsl:template>

</xsl:stylesheet>
