<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:amef="http://www.opengroup.org/xsd/archimate/3.0/"
  xmlns:archimate="http://bp4mc2.org/def/archimate#"

  exclude-result-prefixes="amef xs xsi"
>

<xsl:output method="xml" indent="yes"/>

<xsl:variable name="archimatens">http://bp4mc2.org/archimate/</xsl:variable>
<xsl:variable name="archimateprefix">http://bp4mc2.org/def/archimate#</xsl:variable>
<xsl:param name="args"/>
<xsl:variable name="domain">
  <xsl:choose>
    <xsl:when test="$args != ''">
        <xsl:value-of select="$args " />
    </xsl:when>
    <xsl:otherwise>
        <xsl:value-of select="$archimatens" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:key name="rel" match="/amef:model/amef:relationships/amef:relationship" use="@source"/>
<xsl:key name="relinv" match="/amef:model/amef:relationships/amef:relationship" use="@target"/>

<xsl:template match="*" mode="languagenode">
  <xsl:if test="@xml:lang!=''"><xsl:attribute name="xml:lang"><xsl:value-of select="@xml:lang"/></xsl:attribute></xsl:if>
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="amef:relationship" mode="relname">
  <xsl:choose>
    <xsl:when test="@xsi:type='Access' and @accessType='Read'">readAccess</xsl:when>
    <xsl:when test="@xsi:type='Access' and @accessType='ReadWrite'">readWriteAccess</xsl:when>
    <xsl:when test="@xsi:type='Access' and @accessType='Write'">writeAccess</xsl:when>
    <xsl:otherwise><xsl:value-of select="lower-case(@xsi:type)"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="/">
	<xsl:variable name="context">		
    <xsl:value-of select="$domain"/>    
		<xsl:value-of select="lower-case(replace(amef:model/amef:name,' ','-'))"/>
	</xsl:variable>
  <rdf:RDF>
		<xsl:for-each select="amef:model/amef:propertyDefinitions/amef:propertyDefinition">
			<owl:DatatypeProperty rdf:about="{$context}/{@identifier}">
				<xsl:for-each select="amef:name">
          <rdfs:label><xsl:apply-templates select="." mode="languagenode"/></rdfs:label>
        </xsl:for-each>
			</owl:DatatypeProperty>
		</xsl:for-each>
    <xsl:for-each select="amef:model/amef:elements/amef:element">
      <xsl:element name="archimate:{@xsi:type}">
        <xsl:attribute name="rdf:about"><xsl:value-of select="archimate:URI-minter($context, .)" /></xsl:attribute>
        <xsl:for-each select="amef:name">
          <rdfs:label><xsl:apply-templates select="." mode="languagenode"/></rdfs:label>
        </xsl:for-each>
        <xsl:for-each select="amef:documentation">
          <rdfs:comment><xsl:apply-templates select="." mode="languagenode"/></rdfs:comment>
        </xsl:for-each>
				<xsl:for-each select="amef:properties/amef:property">
					<xsl:element name="property:{@propertyDefinitionRef}" namespace="{$context}/">
						<xsl:apply-templates select="amef:value" mode="languagenode"/>
					</xsl:element>
				</xsl:for-each>
        <xsl:for-each select="key('rel',@identifier)">
          <xsl:variable name="name"><xsl:apply-templates select="." mode="relname"/></xsl:variable>
          <xsl:element name="archimate:{$name}">
            <xsl:attribute name="rdf:resource"><xsl:value-of select="archimate:URI-minter($context, //*[@identifier=current()/@target])" /> </xsl:attribute>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:for-each>
    <xsl:for-each select="amef:model/amef:relationships/amef:relationship[exists(*) or exists(key('rel',@identifier)) or exists(key('relinv',@identifier))]">
      <xsl:variable name="name"><xsl:apply-templates select="." mode="relname"/></xsl:variable>
      <rdf:Statement>
        <xsl:attribute name="rdf:about"><xsl:value-of select="archimate:URI-minter($context, .)" /></xsl:attribute>        
        <rdf:subject>
          <xsl:attribute name="rdf:resource">           
            <xsl:value-of select="archimate:URI-minter($context, //*[@identifier=current()/@source])" />            
          </xsl:attribute>
        </rdf:subject>              
        <rdf:object>
          <xsl:attribute name="rdf:resource">           
            <xsl:value-of select="archimate:URI-minter($context, //*[@identifier=current()/@target])" />            
          </xsl:attribute>  
        </rdf:object>
        <rdf:predicate rdf:resource="{$archimateprefix}{$name}"/>
        <xsl:for-each select="amef:name">
          <rdfs:label><xsl:apply-templates select="." mode="languagenode"/></rdfs:label>
        </xsl:for-each>
        <xsl:for-each select="amef:documentation">
          <rdfs:comment><xsl:apply-templates select="." mode="languagenode"/></rdfs:comment>
        </xsl:for-each>
				<xsl:for-each select="amef:properties/amef:property">
					<xsl:element name="property:{@propertyDefinitionRef}" namespace="{$context}/">
						<xsl:apply-templates select="amef:value" mode="languagenode"/>
					</xsl:element>
				</xsl:for-each>
        <xsl:for-each select="key('rel',@identifier)">
          <xsl:variable name="name"><xsl:apply-templates select="." mode="relname"/></xsl:variable>
          <xsl:element name="archimate:{$name}">
            <xsl:attribute name="rdf:resource"><xsl:value-of select="archimate:URI-minter($context, //*[@identifier=current()/@target])" /></xsl:attribute>
          </xsl:element>
        </xsl:for-each>
      </rdf:Statement>
    </xsl:for-each>
  </rdf:RDF>
</xsl:template>

<xsl:function name="archimate:URI-minter" as="xs:string">
  <!--<xsl:param name="elementId" as="xs:string"/>-->
  <xsl:param name="domain" as="xs:string"/>
  <xsl:param name="element" as="node()"/>
  <xsl:value-of select="concat($domain, '/id/',  $element/@xsi:type, '/', $element/@identifier)" />
  <!--<xsl:value-of select="concat('http://example.org/', $elementId)" />-->
</xsl:function>

</xsl:stylesheet>
