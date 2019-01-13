<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:amef="http://www.opengroup.org/xsd/archimate/3.0/"
  xmlns:archimate="http://bp4mc2.org/def/archimate#"

  exclude-result-prefixes="amef xs xsi"
>

<xsl:output method="xml" indent="yes"/>

<xsl:key name="rel" match="/amef:model/amef:relationships/amef:relationship" use="@source"/>

<xsl:template match="*" mode="languagenode">
  <xsl:if test="@xml:lang!=''"><xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute></xsl:if>
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="/">
  <rdf:RDF>
    <xsl:for-each select="amef:model/amef:elements/amef:element">
      <xsl:element name="archimate:{@xsi:type}">
        <xsl:attribute name="rdf:about">urn:uuid:<xsl:value-of select="@identifier"/></xsl:attribute>
        <xsl:for-each select="amef:name">
          <rdfs:label><xsl:apply-templates select="." mode="languagenode"/></rdfs:label>
        </xsl:for-each>
        <xsl:for-each select="amef:documentation">
          <rdfs:comment><xsl:apply-templates select="." mode="languagenode"/></rdfs:comment>
        </xsl:for-each>
        <xsl:for-each select="key('rel',@identifier)">
          <xsl:element name="archimate:{lower-case(@xsi:type)}">
            <xsl:attribute name="rdf:resource">urn:uuid:<xsl:value-of select="@target"/></xsl:attribute>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:for-each>
  </rdf:RDF>
</xsl:template>

</xsl:stylesheet>
