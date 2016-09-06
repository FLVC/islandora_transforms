<?xml version="1.0" encoding="UTF-8"?>
<!-- MADS -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:foxml="info:fedora/fedora-system:def/foxml#" xmlns:mads="http://www.loc.gov/mads/v2"
                  xmlns:result="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns:encoder="xalan://java.net.URLEncoder">

  <xsl:template match="foxml:datastream[@ID='MADS']/foxml:datastreamVersion[last()]"
                name="index_MADS">
    <xsl:param name="content"/>
    <xsl:param name="prefix">MADS_</xsl:param>
    <xsl:param name="suffix">_ms</xsl:param>


    <xsl:for-each select="$content//mads:authority/mads:name[@type='personal']">
      <xsl:variable name="GIVEN" select="./mads:namePart[@type = 'given']"/>
      <xsl:variable name="FAMILY" select="./mads:namePart[@type = 'family']"/>
      <xsl:variable name="DATE" select="./mads:namePart[@type = 'date']"/>
      <xsl:variable name="ID" select="$content//mads:identifier[@type = 'u1']"/>
      <xsl:variable name="FULLNAME" select="concat($GIVEN, ' ', $FAMILY)"/>
      <xsl:variable name="IDENTIFIER" select="concat($FULLNAME, ' (', $ID, ')')"/>
      <xsl:if test="$FULLNAME != ' '">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($prefix, 'fullname', $suffix)"/>
          </xsl:attribute>
          <xsl:value-of select="$FULLNAME"/>
        </field>
      </xsl:if>

      <xsl:if test="$ID != ''">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($prefix, 'disambiguated_fullname', $suffix)"/>
          </xsl:attribute>
          <xsl:value-of select="$IDENTIFIER"/>
        </field>
      </xsl:if>

      <xsl:if test="$GIVEN != ''">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($prefix, 'given', $suffix)"/>
          </xsl:attribute>
          <xsl:value-of select="$GIVEN"/>
        </field>
      </xsl:if>
      <xsl:if test="$FAMILY != ''">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($prefix, 'family', $suffix)"/>
          </xsl:attribute>
          <xsl:value-of select="$FAMILY"/>
        </field>
      </xsl:if>
      <xsl:if test="$DATE != ''">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($prefix, 'authority_date', $suffix)"/>
          </xsl:attribute>
          <xsl:value-of select="$DATE"/>
        </field>
      </xsl:if>
    </xsl:for-each>

    <xsl:for-each select="$content//mads:variant">
      <xsl:variable name="GIVEN" select="./mads:name/mads:namePart[@type = 'given']"/>
      <xsl:variable name="FAMILY" select="./mads:name/mads:namePart[@type = 'family']"/>
      <xsl:variable name="FULLNAME" select="concat($GIVEN, ' ', $FAMILY)"/>
      <xsl:if test="$FULLNAME != ' '">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($prefix, 'variant_fullname', $suffix)"/>
          </xsl:attribute>
          <xsl:value-of select="$FULLNAME"/>
        </field>
      </xsl:if>
      <xsl:if test="$GIVEN != ''">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($prefix, 'variant_given', $suffix)"/>
          </xsl:attribute>
          <xsl:value-of select="$GIVEN"/>
        </field>
      </xsl:if>
      <xsl:if test="$FAMILY != ''">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($prefix, 'variant_family', $suffix)"/>
          </xsl:attribute>
          <xsl:value-of select="$FAMILY"/>
        </field>
      </xsl:if>
    </xsl:for-each>

    <xsl:for-each select="$content//mads:authority/mads:name[@type = 'corporate']/mads:namePart">
      <xsl:if test="not(./@type)">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($prefix, 'department', $suffix)"/>
          </xsl:attribute>
          <xsl:value-of select="normalize-space(text())"/>
        </field>
      </xsl:if>
    </xsl:for-each>

    <xsl:for-each select="$content//mads:authority/mads:name[@type = 'corporate']/mads:namePart[@type = 'date']">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, 'date', $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="normalize-space(text())"/>
      </field>
    </xsl:for-each>

    <xsl:for-each
      select="$content//mads:related[@type = 'parentOrg']/mads:name[@type = 'corporate']/mads:namePart">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, 'parent_institution', $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="normalize-space(text())"/>
      </field>
    </xsl:for-each>

    <xsl:for-each
      select="$content//mads:related[@type = 'earlier']/mads:name[@type = 'corporate']">
      <xsl:variable name="DATE" select="./mads:namePart[@type = 'date']"/>
      <xsl:variable name="PREV_NAME" select="./mads:namePart"/>
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, 'previous_name', $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="concat($PREV_NAME, ', ', $DATE)"/>
      </field>
    </xsl:for-each>

    <xsl:variable name="PID_namespace" select="substring-before($PID, ':')"/>

    <!-- if organization exists in mads, index all parent organizations -->
    <xsl:if test="$content//mads:organization">
      <xsl:variable name="orgsURL">http://ir-dev.digital.flvc.org/flvc_ir_get_parent_organizations/<xsl:value-of select="$PID"/>/datastream/MADS</xsl:variable>
      <xsl:variable name="orgsresults" select="document($orgsURL)"/>
      <xsl:for-each select="$orgsresults//result:organization">
        <field name="MADS_parent_organization_ms">
        <xsl:value-of select="text()"/>
        </field>
        <field name="parent_organization_ms">
        <xsl:value-of select="text()"/>
        </field>
      </xsl:for-each>
    </xsl:if>

    <!-- if parentOrg exists in mads, index all parent organizations -->
    <xsl:if test="$content//mads:related[@type = 'parentOrg']/mads:name[@type = 'corporate']/mads:namePart">
      <xsl:variable name="orgsURL">http://ir-dev.digital.flvc.org/flvc_ir_get_parent_organizations/<xsl:value-of select="$PID"/>/datastream/MADS</xsl:variable>
      <xsl:variable name="orgsresults" select="document($orgsURL)"/>
      <xsl:for-each select="$orgsresults//result:organization">
        <field name="MADS_parent_department_ms">
        <xsl:value-of select="text()"/>
        </field>
      </xsl:for-each>
    </xsl:if>

    <xsl:for-each select="$content//*">
      <xsl:if test="text() [normalize-space(.) ] and local-name(.) != 'namePart'">
        <field>
          <xsl:choose>
            <xsl:when test="@*">
              <xsl:attribute name="name">
                <xsl:value-of select="concat($prefix, ./@*, $suffix)"/>
              </xsl:attribute>
              <xsl:value-of select="normalize-space(text())"/>
            </xsl:when>

            <xsl:otherwise>
              <xsl:attribute name="name">
                <xsl:value-of select="concat($prefix, local-name(.), $suffix)"/>
              </xsl:attribute>
              <xsl:value-of select="normalize-space(text())"/>
            </xsl:otherwise>
          </xsl:choose>
        </field>
      </xsl:if>
    </xsl:for-each>

  </xsl:template>
</xsl:stylesheet>
