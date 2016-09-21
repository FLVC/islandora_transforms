<?xml version="1.0" encoding="UTF-8"?>
<!-- RELS-EXT -->
<xsl:stylesheet version="1.0"
  xmlns:java="http://xml.apache.org/xalan/java"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:fedora="info:fedora/fedora-system:def/relations-external#"
  xmlns:fedora-model="info:fedora/fedora-system:def/model#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:islandora="http://islandora.ca/ontology/relsext#"
  xmlns:result="http://www.w3.org/2001/sw/DataAccess/rf1/result"
  xmlns:encoder="xalan://java.net.URLEncoder"
     exclude-result-prefixes="rdf java">
  
    <xsl:variable name="single_valued_hashset_for_rels_ext" select="java:java.util.HashSet.new()"/>
    <xsl:template match="foxml:datastream[@ID='RELS-EXT']/foxml:datastreamVersion[last()]" name='index_RELS-EXT'>
	    <xsl:param name="content"/>
	    <xsl:param name="prefix">RELS_EXT_</xsl:param>
	    <xsl:param name="suffix">_ms</xsl:param>
	    
	    <xsl:for-each select="$content//rdf:Description/*[@rdf:resource] | $content//rdf:description/*[@rdf:resource]">
			<field>
			     <xsl:attribute name="name">
			         <xsl:value-of select="concat($prefix, local-name(), '_uri', $suffix)"/>
			     </xsl:attribute>
			     <xsl:value-of select="@rdf:resource"/>
            </field>
	    </xsl:for-each>
	    <xsl:for-each select="$content//rdf:Description/*[not(@rdf:resource)][normalize-space(text())] | $content//rdf:description/*[not(@rdf:resource)][normalize-space(text())]">
              <xsl:choose>
                <xsl:when
                    test="java:add($single_valued_hashset_for_rels_ext, concat($prefix, local-name(), '_literal_s'))">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($prefix, local-name(), '_literal_s')"/>
                        </xsl:attribute>
                        <xsl:value-of select="text()"/>
                    </field>
                    <xsl:if test="@rdf:datatype = 'http://www.w3.org/2001/XMLSchema#int'">
                        <field>
                            <xsl:attribute name="name">
                                <xsl:value-of select="concat($prefix, local-name(), '_literal_l')"/>
                            </xsl:attribute>
                            <xsl:value-of select="text()"/>
                        </field>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
			<field>
		        <xsl:attribute name="name">
			        <xsl:value-of select="concat($prefix, local-name(), '_literal', $suffix)"/>
		        </xsl:attribute>
			    <xsl:value-of select="text()"/>
                        </field>
                </xsl:otherwise>
              </xsl:choose>
	    </xsl:for-each>

            <xsl:for-each select="$content//rdf:Description/fedora:isMemberOfCollection[@rdf:resource]">
                <field name="parent_collection_id_ms">
                <xsl:value-of select="@rdf:resource"/>
                </field>
                <xsl:if test="contains(@rdf:resource,':root')">
                  <field name="site_collection_id_ms">
                  <xsl:value-of select="@rdf:resource"/>
                  </field>
                </xsl:if>
                <xsl:variable name="walk_from_collection_pid">
                <xsl:value-of select="@rdf:resource"/>
                </xsl:variable>
                <xsl:variable name="query">select+%3Fobject+from+%3C%23ri%3E+where+%7B%3Fobject+%3Cfedora-model:hasModel%3E+%3Cinfo:fedora/islandora:collectionCModel%3E+%2E+%3C<xsl:value-of select="$walk_from_collection_pid"/>%3E+%3Cfedora-rels-ext:isMemberOfCollection%3E%2B+%3Fobject+%2E+%7D</xsl:variable>
                <xsl:variable name="sparqlUrl">http://localhost:8080/fedora/risearch?type=tuples&amp;lang=sparql&amp;limit=1000&amp;format=Sparql&amp;query=<xsl:value-of select="$query"/></xsl:variable>
                <xsl:variable name="sparql" select="document($sparqlUrl)"/>
                <xsl:for-each select="$sparql//result:object">
                  <field name="parent_collection_id_ms">
                  <xsl:value-of select="@uri"/>
                  </field>
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
                <xsl:variable name="query2">select+%3Fobject+from+%3C%23ri%3E+where+%7B%3Fobject+%3Cfedora-model:hasModel%3E+%3Cinfo:fedora/islandora:collectionCModel%3E+%2E+%3C<xsl:value-of select="$walk_from_parent_object_pid"/>%3E+%3Cfedora-rels-ext:isMemberOfCollection%3E%2B+%3Fobject+%2E+%7D</xsl:variable>
                <xsl:variable name="sparqlUrl2">http://localhost:8080/fedora/risearch?type=tuples&amp;lang=sparql&amp;limit=1000&amp;format=Sparql&amp;query=<xsl:value-of select="$query2"/></xsl:variable>
                <xsl:variable name="sparql2" select="document($sparqlUrl2)"/>
                <xsl:for-each select="$sparql2//result:object">
                  <field name="parent_collection_id_ms">
                  <xsl:value-of select="@uri"/>
                  </field>
                  <xsl:if test="contains(@uri,':root')">
                    <field name="site_collection_id_ms">
                    <xsl:value-of select="@uri"/>
                    </field>
                  </xsl:if>
                  <xsl:if test="$content//rdf:Description/fedora-model:hasModel[@rdf:resource='info:fedora/islandora:intermediateCModel']">
                      <field name="parent_serial_id_ms">
                      <xsl:value-of select="$content//rdf:Description/fedora:isMemberOf/@rdf:resource"/>
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
            </xsl:if>

            <xsl:for-each select="($content//rdf:Description/fedora:isMemberOf[@rdf:resource])[1] | ($content//rdf:Description/islandora:isComponentOf[@rdf:resource])[1]">
                <xsl:variable name="top_parent_query">select+%3Fobject+%3Fcollection+from+%3C%23ri%3E+where+%7B%3Fobject+%3Cfedora-rels-ext:isMemberOfCollection%3E+%3Fcollection+%2E+%3C<xsl:value-of select="@rdf:resource"/>%3E+%3Cfedora-rels-ext:isMemberOf%3E%2B+%3Fobject+%2E+%7D</xsl:variable>
                <xsl:variable name="top_parent_sparqlUrl">http://localhost:8080/fedora/risearch?type=tuples&amp;lang=sparql&amp;limit=1000&amp;format=Sparql&amp;query=<xsl:value-of select="$top_parent_query"/></xsl:variable>
                <xsl:variable name="top_parent_sparql" select="document($top_parent_sparqlUrl)"/>
                <xsl:for-each select="($top_parent_sparql//result:object)[1]">

                    <xsl:if test="$content//rdf:Description/fedora-model:hasModel[@rdf:resource='info:fedora/islandora:newspaperPageCModel']">
                        <field name="parent_newspaper_id_ms">
                        <xsl:value-of select="@uri"/>
                        </field>
                    </xsl:if>

                    <xsl:if test="$content//rdf:Description/fedora-model:hasModel[@rdf:resource='info:fedora/islandora:intermediateCModel']">
                        <field name="parent_serial_id_ms">
                        <xsl:value-of select="@uri"/>
                        </field>
                    </xsl:if>

                    <xsl:if test="$content//rdf:Description/fedora-model:hasModel[@rdf:resource='info:fedora/islandora:sp_pdf']">
                        <field name="parent_serial_id_ms">
                        <xsl:value-of select="@uri"/>
                        </field>
                    </xsl:if>

                    <xsl:if test="$content//rdf:Description/fedora-model:hasModel[@rdf:resource='info:fedora/islandora:intermediateSerialCModelStub']">
                        <field name="parent_serial_id_ms">
                        <xsl:value-of select="@uri"/>
                        </field>
                    </xsl:if>

                    <xsl:variable name="query3">select+%3Fobject+from+%3C%23ri%3E+where+%7B%3Fobject+%3Cfedora-model:hasModel%3E+%3Cinfo:fedora/islandora:collectionCModel%3E+%2E+%3C<xsl:value-of select="@uri"/>%3E+%3Cfedora-rels-ext:isMemberOfCollection%3E%2B+%3Fobject+%2E+%7D</xsl:variable>
                    <xsl:variable name="sparqlUrl3">http://localhost:8080/fedora/risearch?type=tuples&amp;lang=sparql&amp;limit=1000&amp;format=Sparql&amp;query=<xsl:value-of select="$query3"/></xsl:variable>
                    <xsl:variable name="sparql3" select="document($sparqlUrl3)"/>
                    <xsl:for-each select="$sparql3//result:object">
                      <field name="parent_collection_id_ms">
                      <xsl:value-of select="@uri"/>
                      </field>
                      <xsl:if test="contains(@uri,':root')">
                        <field name="site_collection_id_ms">
                        <xsl:value-of select="@uri"/>
                        </field>
                      </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>

  </xsl:template>
  
</xsl:stylesheet>
