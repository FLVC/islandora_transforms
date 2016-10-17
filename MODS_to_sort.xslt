<?xml version="1.0" encoding="UTF-8"?>
<!-- MODS sort fields - title and author -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:result="http://www.w3.org/2001/sw/DataAccess/rf1/result"
  xmlns:encoder="xalan://java.net.URLEncoder"
     exclude-result-prefixes="mods">

  <xsl:template match="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]" name="index_MODS_sort" mode="sort">
    <xsl:param name="content"/>
    <xsl:param name="prefix">mods_</xsl:param>
    <xsl:param name="suffix">_ms</xsl:param>

    <xsl:call-template name="find_sort_fields">
      <xsl:with-param name="modscontent" select="$content/mods:mods"/>
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
    </xsl:call-template>

    <xsl:call-template name="find_extension_fields">
      <xsl:with-param name="modsextension" select="$content/mods:mods/mods:extension"/>
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="find_sort_fields">
    <xsl:param name="modscontent"/>
    <xsl:param name="prefix">mods_</xsl:param>
    <xsl:param name="suffix">_ms</xsl:param>

    <xsl:choose>
        <xsl:when test="$modscontent/mods:titleInfo[not(@type)]/mods:title[normalize-space(text())]">
            <field name="title_sort">
            <xsl:for-each select="($modscontent/mods:titleInfo[not(@type)]/mods:title[normalize-space(text())])[1]">
                <xsl:value-of select="normalize-space(../mods:title/text())"/>
                <xsl:if test="../mods:subTitle[normalize-space(text())]">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="normalize-space(../mods:subTitle/text())"/>
                </xsl:if>
            </xsl:for-each>
            </field>
        </xsl:when>
        <xsl:when test="$modscontent/mods:titleInfo/mods:title[normalize-space(text())]">
            <field name="title_sort">
            <xsl:for-each select="($modscontent/mods:titleInfo/mods:title[normalize-space(text())])[1]">
                <xsl:value-of select="normalize-space(../mods:title/text())"/>
                <xsl:if test="../mods:subTitle[normalize-space(text())]">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="normalize-space(../mods:subTitle/text())"/>
                </xsl:if>
            </xsl:for-each>
            </field>
        </xsl:when>
    </xsl:choose>

    <xsl:choose>
        <xsl:when test="$modscontent/mods:name/mods:role/mods:roleTerm[text()='creator' or text()='cre']">
            <xsl:for-each select="$modscontent/mods:name/mods:role/mods:roleTerm[text()='creator' or text()='cre']">
                <xsl:if test="(position()=1) and (../../mods:namePart[normalize-space(text())])">
                  <field name="author_sort">
                  <xsl:value-of select="normalize-space(../../mods:namePart/text())"/>
                  </field>
                </xsl:if>
            </xsl:for-each>
        </xsl:when>
        <xsl:when test="$modscontent/mods:name/mods:namePart[not(@type)][normalize-space(text())]">
            <field name="author_sort">
            <xsl:value-of select="normalize-space($modscontent/mods:name/mods:namePart[not(@type)]/text())"/>
            </field>
        </xsl:when>
        <xsl:when test="$modscontent/mods:name/mods:namePart[@type='family'][normalize-space(text())]">
            <field name="author_sort">
            <xsl:value-of select="normalize-space($modscontent/mods:name/mods:namePart[@type='family']/text())"/>
            </field>
        </xsl:when>
        <xsl:when test="$modscontent/mods:name/mods:namePart[@type='given'][normalize-space(text())]">
            <field name="author_sort">
            <xsl:value-of select="normalize-space($modscontent/mods:name/mods:namePart[@type='given']/text())"/>
            </field>
        </xsl:when>
    </xsl:choose>

    <xsl:choose>
        <xsl:when test="$modscontent/mods:originInfo/mods:dateIssued[normalize-space(text())]">
            <xsl:variable name="dateValue">
              <xsl:call-template name="get_ISO8601_date">
                <xsl:with-param name="date" select="normalize-space($modscontent/mods:originInfo/mods:dateIssued/text())"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="string-length($dateValue)>0">
              <field name="date_sort_dt">
              <xsl:value-of select="$dateValue"/>
              </field>
            </xsl:if>
        </xsl:when>
        <xsl:when test="$modscontent/mods:originInfo/mods:dateCreated[normalize-space(text())]">
            <xsl:variable name="dateValue">
              <xsl:call-template name="get_ISO8601_date">
                <xsl:with-param name="date" select="normalize-space($modscontent/mods:originInfo/mods:dateCreated/text())"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="string-length($dateValue)>0">
              <field name="date_sort_dt">
              <xsl:value-of select="$dateValue"/>
              </field>
            </xsl:if>
        </xsl:when>
    </xsl:choose>

    <!-- adding display fields -->
    <xsl:choose>
        <xsl:when test="$modscontent/mods:titleInfo[not(@type)]/mods:title[normalize-space(text())]">
            <field name="title_display_ms">
            <xsl:for-each select="($modscontent/mods:titleInfo[not(@type)]/mods:title[normalize-space(text())])[1]">
                <xsl:if test="../mods:nonSort[normalize-space(text())]">
                    <xsl:value-of select="normalize-space(../mods:nonSort/text())"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:variable name="resulttitle"><xsl:value-of select="normalize-space(../mods:title/text())"/></xsl:variable>
                <xsl:choose>
                    <xsl:when test="substring($resulttitle, string-length($resulttitle), 1) = '.'">
                        <xsl:value-of select="substring($resulttitle,1,string-length($resulttitle)-1)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$resulttitle"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="../mods:subTitle[normalize-space(text())]">
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="normalize-space(../mods:subTitle/text())"/>
                </xsl:if>
                <xsl:text>.</xsl:text>
                <xsl:for-each select="../mods:partNumber[normalize-space(text())]">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="normalize-space(text())"/>
                    <xsl:text>.</xsl:text>
                </xsl:for-each>
                <xsl:for-each select="../mods:partName[normalize-space(text())]">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="normalize-space(text())"/>
                    <xsl:text>.</xsl:text>
                </xsl:for-each>
            </xsl:for-each>
            </field>
        </xsl:when>
        <xsl:when test="$modscontent/mods:titleInfo/mods:title[normalize-space(text())]">
            <field name="title_display_ms">
            <xsl:for-each select="($modscontent/mods:titleInfo/mods:title[normalize-space(text())])[1]">
                <xsl:if test="../mods:nonSort[normalize-space(text())]">
                    <xsl:value-of select="normalize-space(../mods:nonSort/text())"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:variable name="resulttitle2"><xsl:value-of select="normalize-space(../mods:title/text())"/></xsl:variable>
                <xsl:choose>
                    <xsl:when test="substring($resulttitle2, string-length($resulttitle2), 1) = '.'">
                        <xsl:value-of select="substring($resulttitle2,1,string-length($resulttitle2)-1)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$resulttitle2"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="../mods:subTitle[normalize-space(text())]">
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="normalize-space(../mods:subTitle/text())"/>
                </xsl:if>
                <xsl:text>.</xsl:text>
                <xsl:for-each select="../mods:partNumber[normalize-space(text())]">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="normalize-space(text())"/>
                    <xsl:text>.</xsl:text>
                </xsl:for-each>
                <xsl:for-each select="../mods:partName[normalize-space(text())]">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="normalize-space(text())"/>
                    <xsl:text>.</xsl:text>
                </xsl:for-each>
            </xsl:for-each>
            </field>
        </xsl:when>
    </xsl:choose>

    <xsl:for-each select="$modscontent/mods:titleInfo/mods:title[normalize-space(text())]">
        <field name="mods_titleInfo_display_ms">
        <xsl:if test="../mods:nonSort[normalize-space(text())]">
            <xsl:value-of select="normalize-space(../mods:nonSort/text())"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:variable name="maintitle"><xsl:value-of select="normalize-space(../mods:title/text())"/></xsl:variable>
        <xsl:choose>
            <xsl:when test="substring($maintitle, string-length($maintitle), 1) = '.'">
                <xsl:value-of select="substring($maintitle,1,string-length($maintitle)-1)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$maintitle"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="../mods:subTitle[normalize-space(text())]">
            <xsl:text>: </xsl:text>
            <xsl:value-of select="normalize-space(../mods:subTitle/text())"/>
        </xsl:if>
        <xsl:text>.</xsl:text>
        <xsl:for-each select="../mods:partNumber[normalize-space(text())]">
            <xsl:text> </xsl:text>
            <xsl:value-of select="normalize-space(text())"/>
            <xsl:text>.</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="../mods:partName[normalize-space(text())]">
            <xsl:text> </xsl:text>
            <xsl:value-of select="normalize-space(text())"/>
            <xsl:text>.</xsl:text>
        </xsl:for-each>
        </field>
    </xsl:for-each>

    <xsl:for-each select="$modscontent/mods:subject/mods:titleInfo/mods:title[normalize-space(text())]">
        <field name="mods_subject_titleInfo_display_ms">
        <xsl:if test="../mods:nonSort[normalize-space(text())]">
            <xsl:value-of select="normalize-space(../mods:nonSort/text())"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:variable name="subjecttitle"><xsl:value-of select="normalize-space(../mods:title/text())"/></xsl:variable>
        <xsl:choose>
            <xsl:when test="substring($subjecttitle, string-length($subjecttitle), 1) = '.'">
                <xsl:value-of select="substring($subjecttitle,1,string-length($subjecttitle)-1)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$subjecttitle"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="../mods:subTitle[normalize-space(text())]">
            <xsl:text>: </xsl:text>
            <xsl:value-of select="normalize-space(../mods:subTitle/text())"/>
        </xsl:if>
        <xsl:text>.</xsl:text>
        <xsl:for-each select="../mods:partNumber[normalize-space(text())]">
            <xsl:text> </xsl:text>
            <xsl:value-of select="normalize-space(text())"/>
            <xsl:text>.</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="../mods:partName[normalize-space(text())]">
            <xsl:text> </xsl:text>
            <xsl:value-of select="normalize-space(text())"/>
            <xsl:text>.</xsl:text>
        </xsl:for-each>
        </field>
    </xsl:for-each>

    <xsl:for-each select="$modscontent/mods:relatedItem/mods:titleInfo/mods:title[normalize-space(text())]">
        <field name="mods_relatedItem_titleInfo_display_ms">
        <xsl:if test="../mods:nonSort[normalize-space(text())]">
            <xsl:value-of select="normalize-space(../mods:nonSort/text())"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:variable name="relatedtitle"><xsl:value-of select="normalize-space(../mods:title/text())"/></xsl:variable>
        <xsl:choose>
            <xsl:when test="substring($relatedtitle, string-length($relatedtitle), 1) = '.'">
                <xsl:value-of select="substring($relatedtitle,1,string-length($relatedtitle)-1)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$relatedtitle"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="../mods:subTitle[normalize-space(text())]">
            <xsl:text>: </xsl:text>
            <xsl:value-of select="normalize-space(../mods:subTitle/text())"/>
        </xsl:if>
        <xsl:text>.</xsl:text>
        <xsl:for-each select="../mods:partNumber[normalize-space(text())]">
            <xsl:text> </xsl:text>
            <xsl:value-of select="normalize-space(text())"/>
            <xsl:text>.</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="../mods:partName[normalize-space(text())]">
            <xsl:text> </xsl:text>
            <xsl:value-of select="normalize-space(text())"/>
            <xsl:text>.</xsl:text>
        </xsl:for-each>
        </field>
    </xsl:for-each>

    <xsl:for-each select="$modscontent/mods:name">
        <xsl:if test="mods:namePart[not(@type)][normalize-space(text())]">
            <field name="mods_name_namePart_display_ms">
            <xsl:value-of select="normalize-space(mods:namePart[not(@type)]/text())"/>
            </field>
        </xsl:if>
        <xsl:if test="mods:namePart[@type='family' or @type='given'][normalize-space(text())]">
            <field name="mods_name_namePart_display_ms">
            <xsl:if test="mods:namePart[@type='family'][normalize-space(text())]">
                <xsl:value-of select="normalize-space(mods:namePart[@type='family']/text())"/>
            </xsl:if>
            <xsl:if test="mods:namePart[@type='given'][normalize-space(text())]">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="normalize-space(mods:namePart[@type='given']/text())"/>
            </xsl:if>
            </field>
        </xsl:if>
    </xsl:for-each>

    <xsl:for-each select="$modscontent/mods:subject/mods:name">
        <xsl:if test="mods:namePart[not(@type)][normalize-space(text())]">
            <field name="mods_subject_name_namePart_display_ms">
            <xsl:value-of select="normalize-space(mods:namePart[not(@type)]/text())"/>
            </field>
        </xsl:if>
        <xsl:if test="mods:namePart[@type='family' or @type='given'][normalize-space(text())]">
            <field name="mods_subject_name_namePart_display_ms">
            <xsl:if test="mods:namePart[@type='family'][normalize-space(text())]">
                <xsl:value-of select="normalize-space(mods:namePart[@type='family']/text())"/>
            </xsl:if>
            <xsl:if test="mods:namePart[@type='given'][normalize-space(text())]">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="normalize-space(mods:namePart[@type='given']/text())"/>
            </xsl:if>
            </field>
        </xsl:if>
    </xsl:for-each>

    <xsl:variable name="PID_namespace" select="substring-before($PID, ':')"/>
    <xsl:variable name="site_prefix">
      <xsl:choose>
        <xsl:when test="$PID_namespace=islandora">
          <xsl:value-of select="ir"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$PID_namespace"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- if nameIdentifier exists in mods, index all parent organizations -->
    <xsl:if test="$modscontent/mods:name/mods:nameIdentifier">
      <xsl:variable name="orgURL">http://<xsl:value-of select="$site_prefix"/>-test.digital.flvc.org/flvc_ir_get_parent_organizations/<xsl:value-of select="$PID"/>/datastream/MODS</xsl:variable>
      <xsl:variable name="orgresults" select="document($orgURL)"/>
      <xsl:for-each select="$orgresults//result:organization">
        <field name="mods_parent_organization_ms">
        <xsl:value-of select="text()"/>
        </field>
        <field name="parent_organization_ms">
        <xsl:value-of select="text()"/>
        </field>
      </xsl:for-each>
    </xsl:if>

    <!-- additional processing to include type in field name -->
    <!-- DOI, ISSN, ISBN, and any other typed IDs -->
    <xsl:for-each select="$modscontent/mods:identifier[@type][normalize-space(text())]">
      <xsl:if test="string-length(@type) &gt; 0">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($prefix, local-name(), '_', translate(@type, ' ABCDEFGHIJKLMNOPQRSTUVWXYZ', '_abcdefghijklmnopqrstuvwxyz'), $suffix)"/>
          </xsl:attribute>
          <!--<xsl:value-of select="translate(text(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>-->
          <xsl:value-of select="text()"/>
        </field>
      </xsl:if>
    </xsl:for-each>

    <!-- additional processing to include type in field name -->
    <!-- note with type compound -->
    <xsl:for-each select="$modscontent/mods:note[@type='compound'][normalize-space(text())]">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($prefix, local-name(), '_', @type, $suffix)"/>
          </xsl:attribute>
          <xsl:value-of select="text()"/>
        </field>
    </xsl:for-each>

  </xsl:template>

  <xsl:template name="find_extension_fields">
    <xsl:param name="modsextension"/>
    <xsl:param name="prefix">mods_extension_</xsl:param>
    <xsl:param name="suffix">_ms</xsl:param>

    <xsl:for-each select="$modsextension/*/*[normalize-space(text())]">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat('mods_extension_', local-name(), $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="text()"/>
      </field>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
