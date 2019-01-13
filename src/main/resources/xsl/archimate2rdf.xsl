<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:amef="http://www.opengroup.org/xsd/archimate/3.0/"
  xmlns:archimate="http://bp4mc2.org/def/archimate#"
>

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
  <rdf:RDF>
    <xsl:for-each select="amef:model/amef:elements/amef:element">
      <xsl:element name="archimate:{@xsi:type}">
        <xsl:attribute name="rdf:about">urn:uuid:<xsl:value-of select="@identifier"/></xsl:attribute>
        <rdfs:label>
            <xsl:if test="amef:name/@xml:lang!=''"><xsl:attribute name="xml:lang"><xsl:value-of select="amef:name/@xml:lang"/></xsl:attribute></xsl:if>
            <xsl:value-of select="amef:name"/>
        </rdfs:label>
      </xsl:element>
    </xsl:for-each>
  </rdf:RDF>
</xsl:template>

</xsl:stylesheet>
