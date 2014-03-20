<?xml version="1.0" encoding="UTF-8"?>
<!-- OCR glob into one field for indexing-->
<xsl:stylesheet version="1.0"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exts="xalan://dk.defxws.fedoragsearch.server.GenericOperationsImpl"
  xmlns:islandora-exts="xalan://ca.upei.roblib.DataStreamForXSLT"
            exclude-result-prefixes="exts">
  <!-- Datastreams: OCR, TEXT, FULL_TEXT, ocr, text, full_text, fullText
      will probably need to have many templates match and feed into one?
      this file would then be re-named match all text datastreams
  -->
  <xsl:template match="foxml:datastream/foxml:datastreamVersion[last()][@MIMETYPE='application/pdf']" name="index_pdf_text">

    <xsl:param name="content"/>

    <field>
      <xsl:attribute name="name">
        <xsl:value-of select="concat('pdftext', '_t')"/>
      </xsl:attribute>
      <!--<xsl:value-of select="$content"/>-->
      <xsl:value-of select="$content"/>
    </field>
  </xsl:template>
</xsl:stylesheet>
