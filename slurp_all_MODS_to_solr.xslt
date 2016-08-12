<?xml version="1.0" encoding="UTF-8"?>
<!-- Basic MODS -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:mods="http://www.loc.gov/mods/v3"
     exclude-result-prefixes="mods">
  <!-- <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/FgsIndex/islandora_transforms/library/xslt-date-template.xslt"/>-->
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/library/xslt-date-template.xslt"/>
  
  <xsl:template match="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]" name="index_MODS">
    <xsl:param name="content"/>
    <xsl:param name="prefix">mods</xsl:param>
    <xsl:param name="suffix">_ms</xsl:param>

    <xsl:apply-templates select="$content/mods:mods">
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="mods:mods">
    <xsl:param name="prefix">mods</xsl:param>
    <xsl:param name="suffix">_ms</xsl:param>
    
    <xsl:for-each select=".//mods:*[not(@type='date')][not(contains(translate(local-name(), 'D', 'd'), 'date'))][normalize-space(text())]">
    
      <xsl:variable name="fieldName">
        <xsl:call-template name="get_all_parents">
          <xsl:with-param name="node" select="."/>
        </xsl:call-template>
      </xsl:variable>
      
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, $fieldName, $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="normalize-space(text())"/>
      </field>

      <xsl:variable name="fieldNameWithTypes">
        <xsl:call-template name="get_all_parents_with_types">
          <xsl:with-param name="node" select="."/>
        </xsl:call-template>
      </xsl:variable>
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, $fieldNameWithTypes, $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="normalize-space(text())"/>
      </field>

    </xsl:for-each>
    
    <!-- Handle dates. -->
    <xsl:for-each select=".//mods:*[(@type='date') or (contains(translate(local-name(), 'D', 'd'), 'date'))][normalize-space(text())]">
      
      <xsl:variable name="textValue">
        <xsl:call-template name="get_ISO8601_date">
          <xsl:with-param name="date" select="normalize-space(text())"/>
        </xsl:call-template>
      </xsl:variable>
      
      <xsl:variable name="fieldName">
        <xsl:call-template name="get_all_parents">
          <xsl:with-param name="node" select="."/>
        </xsl:call-template>
      </xsl:variable>
     
      <field>
        <xsl:attribute name="name">
        <xsl:choose>
          <xsl:when test="@type='date'">
            <xsl:value-of select="concat($prefix, $fieldName, '_mt')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($prefix, $fieldName, $suffix)"/>
          </xsl:otherwise>
        </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="text()"/>
      </field>

      <xsl:if test="normalize-space($textValue) and string-length($textValue)">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($prefix, $fieldName, '_mdt')"/>
          </xsl:attribute>
          <xsl:value-of select="$textValue"/>
        </field>
      </xsl:if>
    </xsl:for-each>
    
  </xsl:template>
  
  <!-- This is a recursive template that will concatenate
    all the local names of parents of the supplied node.
    This is to provide context to the Solr field.-->
  <xsl:template name="get_all_parents">
    <xsl:param name="node"/>
    
    <xsl:if test="not(local-name($node)='mods')">
      <xsl:call-template name="get_all_parents">
        <xsl:with-param name="node" select="$node/.."/>
      </xsl:call-template>
      <xsl:value-of select="concat('_', local-name($node))"/>
    </xsl:if>
      
  </xsl:template>

  <xsl:template name="get_all_parents_with_types">
    <xsl:param name="node"/>

    <xsl:if test="not(local-name($node)='mods')">
      <xsl:call-template name="get_all_parents_with_types">
        <xsl:with-param name="node" select="$node/.."/>
      </xsl:call-template>
      <xsl:value-of select="concat('_', local-name($node))"/>
      <xsl:if test="$node/@type">
        <xsl:text>_</xsl:text>
        <xsl:value-of select="translate($node/@type,' ','_')"/>
      </xsl:if>
    </xsl:if>

  </xsl:template>
  
</xsl:stylesheet>
