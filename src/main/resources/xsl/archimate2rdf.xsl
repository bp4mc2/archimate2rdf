<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:amef="http://www.opengroup.org/xsd/archimate/3.0/"
  xmlns:archimate="http://bp4mc2.org/def/archimate#"
  xmlns:dbpedia="http://dbpedia.org/ontology/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcat="http://www.w3.org/ns/dcat#"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:dctypes="http://purl.org/dc/dcmitype/"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:schema="http://schema.org/"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
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
<xsl:param name="skos"/>
<xsl:param name="images"/>

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
    <xsl:if test="$skos='true'">
        <xsl:for-each select="amef:model/amef:metadata">
            <xsl:element name="skos:ConceptScheme">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$domain" /></xsl:attribute>
                <xsl:if test="dc:creator!=''">
                     <xsl:element name="dc:creator"><xsl:apply-templates select="dc:creator" mode="languagenode"/></xsl:element>
                </xsl:if>
                <xsl:if test="dc:title!=''">
                    <xsl:element name="dc:title"><xsl:apply-templates select="dc:title" mode="languagenode"/></xsl:element>
                </xsl:if>
                <xsl:if test="dc:subject!=''">
                    <xsl:element name="dc:subject"><xsl:apply-templates select="dc:subject" mode="languagenode"/></xsl:element>
                </xsl:if>
                <xsl:if test="dc:description!=''">
                    <xsl:element name="dc:description"><xsl:apply-templates select="dc:description" mode="languagenode"/></xsl:element>
                </xsl:if>
                <xsl:if test="dc:format!=''">
                    <xsl:element name="dc:format"><xsl:apply-templates select="dc:format" mode="languagenode"/></xsl:element>
                </xsl:if>
                <xsl:if test="dc:language!=''">
                    <xsl:element name="dc:language"><xsl:apply-templates select="dc:language" mode="languagenode"/></xsl:element>
                </xsl:if>
                <xsl:if test="dc:rights!=''">
                    <xsl:element name="dc:rights"><xsl:apply-templates select="dc:rights" mode="languagenode"/></xsl:element>
                </xsl:if>
                <xsl:if test="dc:publisher!=''">
                    <xsl:element name="dc:publisher"><xsl:apply-templates select="dc:publisher" mode="languagenode"/></xsl:element>
                </xsl:if>
                <xsl:if test="dc:date!=''">
                    <xsl:element name="dc:date"><xsl:apply-templates select="dc:date" mode="languagenode"/></xsl:element>
                </xsl:if>
                <xsl:if test="dc:contributor!=''">
                    <xsl:element name="dc:contributor"><xsl:apply-templates select="dc:contributor" mode="languagenode"/></xsl:element>
                </xsl:if>
                <xsl:if test="dc:type!=''">
                    <xsl:element name="dc:type"><xsl:apply-templates select="dc:type" mode="languagenode"/></xsl:element>
                </xsl:if>
                <xsl:if test="dc:identifier!=''">
                    <xsl:element name="dc:identifier"><xsl:apply-templates select="dc:identifier" mode="languagenode"/></xsl:element>
                </xsl:if>
                <xsl:if test="dc:source!=''">
                    <xsl:element name="dc:source"><xsl:apply-templates select="dc:source" mode="languagenode"/></xsl:element>
                </xsl:if>
                <xsl:if test="dc:relation!=''">
                    <xsl:element name="dc:relation"><xsl:apply-templates select="dc:relation" mode="languagenode"/></xsl:element>
                </xsl:if>
                <xsl:if test="dc:coverage!=''">
                    <xsl:element name="dc:coverage"><xsl:apply-templates select="dc:coverage" mode="languagenode"/></xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:for-each>
    </xsl:if>

		<xsl:for-each select="amef:model/amef:propertyDefinitions/amef:propertyDefinition">
            <xsl:choose>
                <xsl:when test="contains(amef:name,':')">
                </xsl:when>
                <xsl:otherwise>
                    <owl:DatatypeProperty rdf:about="{$context}/{@identifier}">
                        <xsl:for-each select="amef:name">
                            <rdfs:label><xsl:apply-templates select="." mode="languagenode"/></rdfs:label>
                        </xsl:for-each>
                    </owl:DatatypeProperty>
                </xsl:otherwise>
            </xsl:choose>
		</xsl:for-each>
    <xsl:for-each select="amef:model/amef:elements/amef:element">
      <xsl:element name="archimate:{@xsi:type}">
        <xsl:attribute name="rdf:about"><xsl:value-of select="archimate:URI-minter($context, .)" /></xsl:attribute>
        <xsl:choose>
            <xsl:when test="$skos='true'">
                <xsl:element name="skos:inScheme">
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$domain" /></xsl:attribute>
                </xsl:element>
                <xsl:element name="skos:topConceptOf">
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$domain" /></xsl:attribute>
                </xsl:element>
                <xsl:element name="rdf:type">
                    <xsl:attribute name="rdf:resource">http://www.w3.org/2004/02/skos/core#Concept</xsl:attribute>
                </xsl:element>
                <xsl:for-each select="amef:name">
                    <skos:prefLabel><xsl:apply-templates select="." mode="languagenode"/></skos:prefLabel>
                </xsl:for-each>
                <xsl:for-each select="amef:documentation">
                    <skos:scopeNote><xsl:apply-templates select="." mode="languagenode"/></skos:scopeNote>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="amef:name">
                    <rdfs:label><xsl:apply-templates select="." mode="languagenode"/></rdfs:label>
                </xsl:for-each>
                <xsl:for-each select="amef:documentation">
                    <rdfs:comment><xsl:apply-templates select="." mode="languagenode"/></rdfs:comment>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
				<xsl:for-each select="amef:properties/amef:property">
                    <xsl:choose>
                        <xsl:when test="contains(/amef:model/amef:propertyDefinitions/amef:propertyDefinition[@identifier=current()/@propertyDefinitionRef]/amef:name,':')">
                                <xsl:choose>
                                    <xsl:when test="starts-with(amef:value,'http') or contains(amef:value, ':')">
                                        <xsl:element name="{/amef:model/amef:propertyDefinitions/amef:propertyDefinition[@identifier=current()/@propertyDefinitionRef]/amef:name}">
                                            <xsl:attribute name="rdf:resource">
                                                <xsl:value-of select="archimate:expandprefix(amef:value)"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="{/amef:model/amef:propertyDefinitions/amef:propertyDefinition[@identifier=current()/@propertyDefinitionRef]/amef:name}">
                                            <xsl:apply-templates select="amef:value" mode="languagenode"/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="property:{@propertyDefinitionRef}" namespace="{$context}/">
                                <xsl:apply-templates select="amef:value" mode="languagenode"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
				</xsl:for-each>
        <xsl:for-each select="key('rel',@identifier)">
          <xsl:variable name="name"><xsl:apply-templates select="." mode="relname"/></xsl:variable>
          <xsl:element name="archimate:{$name}">
            <xsl:attribute name="rdf:resource"><xsl:value-of select="archimate:URI-minter($context, //*[@identifier=current()/@target])" /> </xsl:attribute>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
      <xsl:if test="$skos='true'">
          <xsl:element name="skos:Collection">
              <xsl:attribute name="rdf:about">http://bp4mc2.org/def/archimate#<xsl:value-of select="@xsi:type"/>Group</xsl:attribute>
              <xsl:element name="skos:member">
                  <xsl:attribute name="rdf:resource"><xsl:value-of select="archimate:URI-minter($context, .)" /></xsl:attribute>
              </xsl:element>
          </xsl:element>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="amef:model/amef:relationships/amef:relationship[exists(*) or exists(key('rel',@identifier)) or exists(key('relinv',@identifier))]">
      <xsl:variable name="name"><xsl:apply-templates select="." mode="relname"/></xsl:variable>
      <archimate:Relationship>
        <xsl:attribute name="rdf:about"><xsl:value-of select="archimate:URI-minter($context, .)" /></xsl:attribute>
          <xsl:if test="$skos='true'">
              <xsl:element name="rdf:type">
                  <xsl:attribute name="rdf:resource">http://www.w3.org/2004/02/skos/core#Concept</xsl:attribute>
              </xsl:element>
              <xsl:for-each select="amef:name">
                  <skos:prefLabel><xsl:apply-templates select="." mode="languagenode"/></skos:prefLabel>
              </xsl:for-each>
          </xsl:if>
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
                    <xsl:choose>
                        <xsl:when test="contains(/amef:model/amef:propertyDefinitions/amef:propertyDefinition[@identifier=current()/@propertyDefinitionRef]/amef:name,':')">
                            <xsl:element name="{/amef:model/amef:propertyDefinitions/amef:propertyDefinition[@identifier=current()/@propertyDefinitionRef]/amef:name}">
                                <xsl:apply-templates select="amef:value" mode="languagenode"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="property:{@propertyDefinitionRef}" namespace="{$context}/">
                                <xsl:apply-templates select="amef:value" mode="languagenode"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
				</xsl:for-each>
        <xsl:for-each select="key('rel',@identifier)">
          <xsl:variable name="name"><xsl:apply-templates select="." mode="relname"/></xsl:variable>
          <xsl:element name="archimate:{$name}">
            <xsl:attribute name="rdf:resource"><xsl:value-of select="archimate:URI-minter($context, //*[@identifier=current()/@target])" /></xsl:attribute>
          </xsl:element>
        </xsl:for-each>
      </archimate:Relationship>
        <xsl:if test="$skos='true'">
            <xsl:element name="skos:Collection">
                <xsl:attribute name="rdf:about">http://bp4mc2.org/def/archimate#RelationshipGroup</xsl:attribute>
                <xsl:element name="skos:member">
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="archimate:URI-minter($context, .)" /></xsl:attribute>
                </xsl:element>
            </xsl:element>
            <xsl:element name="skos:Concept">
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="archimate:URI-minter($context, //*[@identifier=current()/@source])" />
                </xsl:attribute>
                <xsl:element name="skos:related">
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="archimate:URI-minter($context, .)" />
                    </xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:for-each>
    <xsl:if test="$skos='true'">
        <xsl:for-each select="amef:model/amef:views/amef:diagrams/amef:view">
            <xsl:element name="skos:Concept">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$domain"/><xsl:value-of select="@identifier"/></xsl:attribute>
                <xsl:element name="skos:prefLabel"><xsl:apply-templates select="amef:name" mode="languagenode"/></xsl:element>
                <xsl:if test="$images!=''">
                    <xsl:element name="rdfs:seeAlso">
                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$images"/><xsl:value-of select="@identifier" />.png</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="foaf:image">
                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$images"/><xsl:value-of select="@identifier" />.png</xsl:attribute>
                    </xsl:element>
                </xsl:if>
                <xsl:for-each select="amef:node">
                    <xsl:if test="current()/@elementRef!=''">
                        <xsl:element name="skos:related">
                            <xsl:attribute name="rdf:resource"><xsl:value-of select="$domain"/>archisurance/id/<xsl:apply-templates select="/amef:model/amef:elements/amef:element[@identifier=current()/@elementRef]/@xsi:type"/>/<xsl:value-of select="current()/@elementRef"/></xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                    <xsl:for-each select="amef:node">
                        <xsl:if test="current()/@elementRef!=''">
                            <xsl:element name="skos:related">
                                <xsl:attribute name="rdf:resource"><xsl:value-of select="$domain"/>archisurance/id/<xsl:apply-templates select="/amef:model/amef:elements/amef:element[@identifier=current()/@elementRef]/@xsi:type"/>/<xsl:value-of select="current()/@elementRef"/></xsl:attribute>
                            </xsl:element>
                            <xsl:for-each select="amef:node">
                                <xsl:element name="skos:related">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$domain"/>archisurance/id/<xsl:apply-templates select="/amef:model/amef:elements/amef:element[@identifier=current()/@elementRef]/@xsi:type"/>/<xsl:value-of select="current()/@elementRef"/></xsl:attribute>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:element name="skos:Collection">
                <xsl:attribute name="rdf:about">http://bp4mc2.org/def/archimate#ViewGroup</xsl:attribute>
                <xsl:element name="skos:member">
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$domain"/><xsl:value-of select="@identifier"/></xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:if>
  </rdf:RDF>
</xsl:template>

<xsl:function name="archimate:URI-minter" as="xs:string">
  <xsl:param name="domain" as="xs:string"/>
  <xsl:param name="element" as="node()"/>
  <xsl:value-of select="concat($domain, '/id/',  $element/@xsi:type, '/', $element/@identifier)" />
</xsl:function>

<xsl:function name="archimate:expandprefix" as="xs:string">
    <xsl:param name="literal" as="xs:string"/>
    <xsl:value-of select="replace(replace(replace(replace(replace(replace(replace(replace(replace(replace($literal,'dcat:', 'http://www.w3.org/ns/dcat#'), 'rdf:', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'), 'rdfs:', 'http://www.w3.org/2000/01/rdf-schema#'), 'dbpedia:', 'http://dbpedia.org/ontology/'), 'dc:', 'http://purl.org/dc/elements/1.1/'), 'dcterms:', 'http://purl.org/dc/terms/'), 'dctypes:', 'http://purl.org/dc/dcmitype/'), 'foaf:', 'http://xmlns.com/foaf/0.1/'), 'schema:', 'http://schema.org/'), 'skos:', 'http://www.w3.org/2004/02/skos/core#')" />
</xsl:function>

</xsl:stylesheet>
