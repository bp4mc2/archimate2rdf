<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
>

<xsl:variable name="comments">
  <classes>Classes</classes>
  <properties>Properties</properties>
</xsl:variable>

<xsl:variable name="prefixes">
  <archimate>http://bp4mc2.org/def/archimate#</archimate>
  <owl>http://www.w3.org/2002/07/owl#</owl>
  <rdfs>http://www.w3.org/2000/01/rdf-schema#</rdfs>
  <rdf>http://www.w3.org/1999/02/22-rdf-syntax-ns#</rdf>
  <skos>http://www.w3.org/2004/02/skos/core#</skos>
</xsl:variable>

<xsl:output method="text" indent="no"/>

<xsl:template match="*" mode="prefix">
  <xsl:text>@prefix </xsl:text><xsl:value-of select="local-name()"/><xsl:text>: </xsl:text>
  <xsl:text>&lt;</xsl:text><xsl:value-of select="."/><xsl:text>&gt;.
</xsl:text>
</xsl:template>

<xsl:template match="*" mode="comment">
  <xsl:text># </xsl:text><xsl:value-of select="."/><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="*" mode="break">
  <xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-templates select="$prefixes/*" mode="prefix"/>
  <xsl:apply-templates select="." mode="break"/>

  <xsl:text>archimate:Relationship a owl:Class;
  rdfs:subClassOf rdf:Statement;
  skos:prefLabel "ArchiMate Relationship"@en
.
</xsl:text>

  <xsl:apply-templates select="$comments/classes" mode="comment"/>
  <xsl:for-each select="xs:schema/xs:complexType[xs:complexContent/xs:extension/@base='RealElementType']">
    <xsl:text>archimate:</xsl:text><xsl:value-of select="@name"/>
    <xsl:text> a owl:Class;
  rdfs:isDefinedBy &lt;http://bp4mc2.org/def/archimate&gt;;
</xsl:text>
    <xsl:text>  rdfs:label "</xsl:text><xsl:value-of select="@name"/><xsl:text>"@en;
.
</xsl:text>
    <xsl:text>archimate:</xsl:text><xsl:value-of select="@name"/><xsl:text>Group</xsl:text>
    <xsl:text> a skos:Collection;
      skos:prefLabel "</xsl:text><xsl:value-of select="@name"/><xsl:text>"@en;
.
</xsl:text>
  </xsl:for-each>

  <xsl:apply-templates select="$comments/properties" mode="comment"/>
  <xsl:for-each select="xs:schema/xs:complexType[xs:complexContent/xs:extension/@base='RelationshipType']">
    <xsl:text>archimate:</xsl:text><xsl:value-of select="lower-case(@name)"/>
    <xsl:text> a owl:ObjectProperty;
</xsl:text>
    <xsl:text>  rdfs:label "</xsl:text><xsl:value-of select="lower-case(@name)"/><xsl:text>"@en;
.
</xsl:text>
  </xsl:for-each>
	<xsl:text>archimate:readAccess a owl:ObjectProperty;
  rdfs:isDefinedBy &lt;http://bp4mc2.org/def/archimate&gt;;
  rdfs:subPropertyOf archimate:access;
  rdfs:label "readAccess"@en;
.
archimate:writeAccess a owl:ObjectProperty;
  rdfs:isDefinedBy &lt;http://bp4mc2.org/def/archimate&gt;;
  rdfs:subPropertyOf archimate:access;
  rdfs:label "writeAccess"@en;
.
archimate:readWriteAccess a owl:ObjectProperty;
  rdfs:isDefinedBy &lt;http://bp4mc2.org/def/archimate&gt;;
  rdfs:subPropertyOf archimate:access;
  rdfs:label "readWriteAccess"@en;
.
archimate:property a owl:DatatypeProperty;
  rdfs:isDefinedBy &lt;http://bp4mc2.org/def/archimate&gt;;
  rdfs:label "property";
.
archimate:composition rdfs:comment "Represents that an element consists of one or more other concepts."@en.
archimate:aggregation rdfs:comment "Represents that an element combines one or more other concepts."@en.
archimate:assignment rdfs:comment "Represents the allocation of responsibility, performance of behavior, storage, or execution."@en.
archimate:realization rdfs:comment "Represents that an entity plays a critical role in the creation, achievement, sustenance, or operation of a more abstract entity."@en.
archimate:serving rdfs:comment "Represents that an element provides its functionality to another element."@en.
archimate:access rdfs:comment "Represents the ability of behavior and active structure elements to observe or act upon passive structure elements."@en.
archimate:influence rdfs:comment "Represents that an element affects the implementation or achievement of some motivation element."@en.
archimate:triggering rdfs:comment "Represents a temporal or causal relationship between elements."@en.
archimate:flow rdfs:comment "Represents transfer from one element to another."@en.
archimate:specialization rdfs:comment "Represents that an element is a particular kind of another element."@en.
archimate:association rdfs:comment "Represents an unspecified relationship, or one that is not represented by another ArchiMate relationship."@en.
archimate:ViewGroup a skos:Collection;
  skos:prefLabel "View"@en
.
archimate:RelationshipGroup a skos:Collection;
  skos:prefLabel "Relationship"@en
.
</xsl:text>
</xsl:template>

</xsl:stylesheet>
