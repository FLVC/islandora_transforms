<?xml version="1.0" encoding="UTF-8"?>
<!-- RELS-EXT -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:fedora="info:fedora/fedora-system:def/relations-external#"
  xmlns:fedora-model="info:fedora/fedora-system:def/model#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:result="http://www.w3.org/2001/sw/DataAccess/rf1/result"
  xmlns:encoder="xalan://java.net.URLEncoder"
     exclude-result-prefixes="rdf">
  
    <xsl:template match="foxml:datastream[@ID='RELS-EXT']/foxml:datastreamVersion[last()]" name='index_RELS-EXT'>
	    <xsl:param name="content"/>
	    <xsl:param name="prefix">RELS_EXT_</xsl:param>
	    <xsl:param name="suffix">_ms</xsl:param>
	    
	    <xsl:for-each select="$content//rdf:Description/*[@rdf:resource]">
			<field>
			     <xsl:attribute name="name">
			         <xsl:value-of select="concat($prefix, local-name(), '_uri', $suffix)"/>
			     </xsl:attribute>
			     <xsl:value-of select="@rdf:resource"/>
            </field>
	    </xsl:for-each>
	    <xsl:for-each select="$content//rdf:Description/*[not(@rdf:resource)][normalize-space(text())]">
			<field>
		        <xsl:attribute name="name">
			        <xsl:value-of select="concat($prefix, local-name(), '_literal', $suffix)"/>
		        </xsl:attribute>
			    <xsl:value-of select="text()"/>
            </field>
	    </xsl:for-each>

            <xsl:for-each select="$content//rdf:Description/fedora:isMemberOfCollection[@rdf:resource]">
                <xsl:variable name="walk_from_collection_pid">
                <xsl:value-of select="@rdf:resource"/>
                </xsl:variable>
                <xsl:variable name="query">select+$object+from+%3C%23ri%3E+where+$subject+%3Cfedora-model:hasModel%3E+%3Cinfo:fedora/islandora:collectionCModel%3E+and+walk%28%3C<xsl:value-of select="$walk_from_collection_pid"/>%3E+%3Cfedora-rels-ext:isMemberOfCollection%3E+$object+and+$subject+%3Cfedora-rels-ext:isMemberOfCollection%3E+$object%29</xsl:variable>
                <xsl:variable name="sparqlUrl">http://localhost:8080/fedora/risearch?type=tuples&amp;lang=itql&amp;limit=1000&amp;format=Sparql&amp;query=<xsl:value-of select="$query"/></xsl:variable>
                <xsl:variable name="sparql" select="document($sparqlUrl)"/>
                <xsl:for-each select="$sparql//result:object">
                  <xsl:if test="contains(@uri,':root')">
                    <field name="site_collection_id_ms">
                    <xsl:value-of select="@uri"/>
                    </field>
                  </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$content//rdf:Description/fedora:isMemberOf[@rdf:resource]">
                <xsl:variable name="walk_from_parent_object_pid">
                <xsl:value-of select="@rdf:resource"/>
                </xsl:variable>
                <xsl:variable name="query2">select+$object+from+%3C%23ri%3E+where+$subject+%3Cfedora-model:hasModel%3E+%3Cinfo:fedora/islandora:collectionCModel%3E+and+walk%28%3C<xsl:value-of select="$walk_from_parent_object_pid"/>%3E+%3Cfedora-rels-ext:isMemberOfCollection%3E+$object+and+$subject+%3Cfedora-rels-ext:isMemberOfCollection%3E+$object%29</xsl:variable>
                <xsl:variable name="sparqlUrl2">http://localhost:8080/fedora/risearch?type=tuples&amp;lang=itql&amp;limit=1000&amp;format=Sparql&amp;query=<xsl:value-of select="$query2"/></xsl:variable>
                <xsl:variable name="sparql2" select="document($sparqlUrl2)"/>
                <xsl:for-each select="$sparql2//result:object">
                  <xsl:if test="contains(@uri,':root')">
                    <field name="site_collection_id_ms">
                    <xsl:value-of select="@uri"/>
                    </field>
                  </xsl:if>
                </xsl:for-each>
            </xsl:for-each>

            <xsl:if test="$content//rdf:Description/fedora-model:hasModel[@rdf:resource='info:fedora/islandora:pageCModel']">
                <field name="parent_book_id_ms">
                <xsl:value-of select="$content//rdf:Description/fedora:isMemberOf/@rdf:resource"/>
                </field>
            </xsl:if>

            <xsl:if test="$content//rdf:Description/fedora-model:hasModel[@rdf:resource='info:fedora/islandora:newspaperIssueCModel']">
                <field name="parent_newspaper_id_ms">
                <xsl:value-of select="$content//rdf:Description/fedora:isMemberOf/@rdf:resource"/>
                </field>
            </xsl:if>

            <xsl:if test="$content//rdf:Description/fedora-model:hasModel[@rdf:resource='info:fedora/islandora:newspaperPageCModel']">
                <field name="parent_issue_id_ms">
                <xsl:value-of select="$content//rdf:Description/fedora:isMemberOf/@rdf:resource"/>
                </field>
                <xsl:variable name="query_newspaper">select+$newspaperobject+from+%3C%23ri%3E+where+%3C<xsl:value-of select="$content//rdf:Description/fedora:isMemberOf/@rdf:resource"/>%3E+%3Cfedora-rels-ext:isMemberOf%3E+$newspaperobject</xsl:variable>
                <xsl:variable name="sparqlUrl_newspaper">http://localhost:8080/fedora/risearch?type=tuples&amp;lang=itql&amp;limit=1000&amp;format=Sparql&amp;query=<xsl:value-of select="$query_newspaper"/></xsl:variable>
                <xsl:variable name="sparql_newspaper" select="document($sparqlUrl_newspaper)"/>
                <xsl:for-each select="$sparql_newspaper//result:newspaperobject">
                    <field name="parent_newspaper_id_ms">
                      <xsl:value-of select="@uri"/>
                    </field>
                    <xsl:variable name="query3">select+$object+from+%3C%23ri%3E+where+$subject+%3Cfedora-model:hasModel%3E+%3Cinfo:fedora/islandora:collectionCModel%3E+and+walk%28%3C<xsl:value-of select="@uri"/>%3E+%3Cfedora-rels-ext:isMemberOfCollection%3E+$object+and+$subject+%3Cfedora-rels-ext:isMemberOfCollection%3E+$object%29</xsl:variable>
                    <xsl:variable name="sparqlUrl3">http://localhost:8080/fedora/risearch?type=tuples&amp;lang=itql&amp;limit=1000&amp;format=Sparql&amp;query=<xsl:value-of select="$query3"/></xsl:variable>
                    <xsl:variable name="sparql3" select="document($sparqlUrl3)"/>
                    <xsl:for-each select="$sparql3//result:object">
                      <xsl:if test="contains(@uri,':root')">
                        <field name="site_collection_id_ms">
                        <xsl:value-of select="@uri"/>
                        </field>
                      </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:if>

  </xsl:template>
  
</xsl:stylesheet>
