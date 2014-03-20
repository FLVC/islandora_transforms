<?xml version="1.0" encoding="UTF-8"?>
<!-- Template to make the iso8601 date -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:java="http://xml.apache.org/xalan/java"
  xmlns:xlink="http://www.w3.org/1999/xlink">
     
  <xsl:template name="get_ISO8601_date">
    <xsl:param name="date"/>
    <xsl:message><xsl:value-of select="$date"/></xsl:message>

    <xsl:variable name="parenchars">()[]</xsl:variable>
    <xsl:variable name="date2">
          <xsl:value-of select="translate($date,$parenchars,'')"/>
    </xsl:variable>
 
    <xsl:variable name="lastchar">
      <xsl:value-of select="substring($date2, string-length($date2), 1)"/>
    </xsl:variable>

    <xsl:variable name="trimdate">
    <xsl:choose>
      <xsl:when test="$lastchar='?' or $lastchar='-'">
          <xsl:value-of select="substring($date2, 1, string-length($date2) - 1)"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="$date2"/>
      </xsl:otherwise>
    </xsl:choose>
    </xsl:variable>

    <xsl:variable name="textmonth_day_year_pattern">(Jan|January|Feb|February|Mar|March|Apr|April|May|Jun|June|Jul|July|Aug|August|Sep|September|Oct|October|Nov|November|Dec|December) [0-9]{1,2} [0-9]{4}</xsl:variable>
    <xsl:variable name="textmonth_year_pattern">(Jan|January|Feb|February|Mar|March|Apr|April|May|Jun|June|Jul|July|Aug|August|Sep|September|Oct|October|Nov|November|Dec|December) [0-9]{4}</xsl:variable>
    <xsl:variable name="day_textmonth_year_pattern">[0-9]{1,2} (Jan|January|Feb|February|Mar|March|Apr|April|May|Jun|June|Jul|July|Aug|August|Sep|September|Oct|October|Nov|November|Dec|December) [0-9]{4}</xsl:variable>

    <xsl:variable name="replacechars">?U.,</xsl:variable>
    <xsl:variable name="newdate">
          <xsl:value-of select="normalize-space(translate($trimdate,$replacechars,'00  '))"/>
    </xsl:variable>
    <xsl:message><xsl:value-of select="$newdate"/></xsl:message>

    <xsl:variable name="datecopy">
          <xsl:value-of select="$newdate"/>
    </xsl:variable>
    <xsl:variable name="date_numbers">
          <xsl:value-of select="normalize-space(translate($datecopy,'-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',' '))"/>
    </xsl:variable>
    <xsl:message><xsl:value-of select="$date_numbers"/></xsl:message>

    <xsl:variable name="pattern1">
      <xsl:variable name="frac">([.,][0-9]+)</xsl:variable>
      <xsl:variable name="sec_el">(\:[0-9]{2}<xsl:value-of select="$frac"/>?)</xsl:variable>
      <xsl:variable name="min_el">(\:[0-9]{2}(<xsl:value-of select="$frac"/>|<xsl:value-of select="$sec_el"/>?))</xsl:variable>
      <xsl:variable name="time_el">([0-9]{2}(<xsl:value-of select="$frac"/>|<xsl:value-of select="$min_el"/>))</xsl:variable>
      <xsl:variable name="time_offset">(Z|[+-]<xsl:value-of select="$time_el"/>)</xsl:variable>
      <xsl:variable name="time_pattern">(T<xsl:value-of select="$time_el"/><xsl:value-of select="$time_offset"/>?)</xsl:variable>

      <xsl:variable name="day_el">(-[0-9]{2})</xsl:variable>
      <xsl:variable name="month_el">(-[0-9]{2}<xsl:value-of select="$day_el"/>?)</xsl:variable>
      <xsl:variable name="date_el">([0-9\?]{4}<xsl:value-of select="$month_el"/>?)</xsl:variable>
      <xsl:variable name="date_opt_pattern">(<xsl:value-of select="$date_el"/><xsl:value-of select="$time_pattern"/>?)</xsl:variable>
      <!--xsl:text>(<xsl:value-of select="$time_pattern"/> | <xsl:value-of select="$date_opt_pattern"/>)</xsl:text-->
      <xsl:value-of select="$date_opt_pattern"/>
    </xsl:variable>

    <xsl:variable name="pattern2">([0-9]{1,2}/)([0-9]{1,2}/)([0-9]{4})</xsl:variable>
    <xsl:variable name="pattern3">([0-9]{1,2}/)?([0-9]{1,2}/)?([0-9]{4}) ([0-9]{1,2}:[0-9]{2})</xsl:variable>
    <xsl:variable name="pattern4">[0-9]{1,2}-[0-9]{1,2}-[0-9]{4}</xsl:variable>
    <xsl:variable name="pattern5">[0-9]{1,2}-[0-9]{4}</xsl:variable>
    <xsl:variable name="pattern6">[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}</xsl:variable>
    <xsl:variable name="pattern7a">[0-9]{4}-[1-9]</xsl:variable>
    <xsl:variable name="pattern7b">[0-9]{4}-[0][1-9]</xsl:variable>
    <xsl:variable name="pattern7c">[0-9]{4}-[1][012]</xsl:variable>
    <xsl:variable name="pattern8">[0-9]{1,2}/[0-9]{4}</xsl:variable>
    <xsl:variable name="pattern9">[0-9]{1,2}/[0-9]{1,2}/[0-9]{2}</xsl:variable>
    <xsl:variable name="pattern_date_beginning">[12][0-9]{3} .*</xsl:variable>
    <xsl:variable name="pattern_date_beginning_leading_digit">[0-9] [12][0-9]{3} .*</xsl:variable>
    <xsl:variable name="pattern_date_beginning_leading_twodigits">[0-9]{2} [12][0-9]{3} .*</xsl:variable>
    <xsl:variable name="pattern_date_ending_double">.* [12][0-9]{3} [12][0-9]{3}</xsl:variable>
    <xsl:variable name="pattern_date_ending_double_abbreviated">.* [12][0-9]{3} [0-9]{2}</xsl:variable>
    <xsl:variable name="pattern_date_ending">.* [12][0-9]{3}</xsl:variable>
    <xsl:variable name="pattern_date_only">[12][0-9]{3}</xsl:variable>

    <!-- Have JODA or fail silently. -->

    <xsl:variable name="parsed">
      <xsl:choose>
        <xsl:when test="java:matches($newdate, $pattern2)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('M/d/y')"/>
          <xsl:value-of select="java:parseDateTime($dp, $newdate)"/>
        </xsl:when>
        <xsl:when test="java:matches($newdate, $pattern3)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('M/d/y H:m')"/>
          <xsl:value-of select="java:parseDateTime($dp, $newdate)"/>
        </xsl:when>
        <xsl:when test="java:matches($newdate, $pattern4)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('M-d-y')"/>
          <xsl:value-of select="java:parseDateTime($dp, $newdate)"/>
        </xsl:when>
        <xsl:when test="java:matches($newdate, $pattern5)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('M-y')"/>
          <xsl:value-of select="java:parseDateTime($dp, $newdate)"/>
        </xsl:when>
        <xsl:when test="java:matches($newdate, $pattern6)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('y-M-d')"/>
          <xsl:value-of select="java:parseDateTime($dp, $newdate)"/>
        </xsl:when>
        <xsl:when test="java:matches($newdate, $pattern7a)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('y-M')"/>
          <xsl:value-of select="java:parseDateTime($dp, $newdate)"/>
        </xsl:when>
        <xsl:when test="java:matches($newdate, $pattern7b)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('y-M')"/>
          <xsl:value-of select="java:parseDateTime($dp, $newdate)"/>
        </xsl:when>
        <xsl:when test="java:matches($newdate, $pattern7c)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('y-M')"/>
          <xsl:value-of select="java:parseDateTime($dp, $newdate)"/>
        </xsl:when>
        <xsl:when test="java:matches($newdate, $pattern8)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('M/y')"/>
          <xsl:value-of select="java:parseDateTime($dp, $newdate)"/>
        </xsl:when>
        <xsl:when test="java:matches($newdate, $pattern9)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('M/d/yy')"/>
          <xsl:value-of select="java:parseDateTime($dp, $newdate)"/>
        </xsl:when>
        <xsl:when test="java:matches($newdate, $textmonth_day_year_pattern)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('MMMM d y')"/>
          <xsl:value-of select="java:parseDateTime($dp, $newdate)"/>
        </xsl:when>
        <xsl:when test="java:matches($newdate, $textmonth_year_pattern)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('MMMM y')"/>
          <xsl:value-of select="java:parseDateTime($dp, $newdate)"/>
        </xsl:when>
        <xsl:when test="java:matches($newdate, $day_textmonth_year_pattern)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('d MMMM y')"/>
          <xsl:value-of select="java:parseDateTime($dp, $newdate)"/>
        </xsl:when>
        <xsl:when test="java:matches($date_numbers, $pattern_date_beginning)">
          <xsl:variable name="year" select="substring($date_numbers,1,4)"/>
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('y')"/>
          <xsl:value-of select="java:parseDateTime($dp, $year)"/>
        </xsl:when>
        <xsl:when test="java:matches($date_numbers, $pattern_date_beginning_leading_digit)">
          <xsl:variable name="year" select="substring($date_numbers,3,4)"/>
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('y')"/>
          <xsl:value-of select="java:parseDateTime($dp, $year)"/>
        </xsl:when>
        <xsl:when test="java:matches($date_numbers, $pattern_date_beginning_leading_twodigits)">
          <xsl:variable name="year" select="substring($date_numbers,4,4)"/>
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('y')"/>
          <xsl:value-of select="java:parseDateTime($dp, $year)"/>
        </xsl:when>
        <xsl:when test="java:matches($date_numbers, $pattern_date_ending_double)">
          <xsl:variable name="year" select="substring($date_numbers,string-length($date_numbers)-8,4)"/>
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('y')"/>
          <xsl:value-of select="java:parseDateTime($dp, $year)"/>
        </xsl:when>
        <xsl:when test="java:matches($date_numbers, $pattern_date_ending_double_abbreviated)">
          <xsl:variable name="year" select="substring($date_numbers,string-length($date_numbers)-6,4)"/>
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('y')"/>
          <xsl:value-of select="java:parseDateTime($dp, $year)"/>
        </xsl:when>
        <xsl:when test="java:matches($date_numbers, $pattern_date_ending)">
          <xsl:variable name="year" select="substring($date_numbers,string-length($date_numbers)-3,4)"/>
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('y')"/>
          <xsl:value-of select="java:parseDateTime($dp, $year)"/>
        </xsl:when>
        <xsl:when test="java:matches($date_numbers, $pattern_date_only)">
          <xsl:variable name="dp" select="java:org.joda.time.format.DateTimeFormat.forPattern('y')"/>
          <xsl:value-of select="java:parseDateTime($dp, $date_numbers)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$newdate"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="asdf" select="string($parsed)"/>
    <xsl:message><xsl:value-of select="$asdf"/></xsl:message>
    <xsl:choose>
    <xsl:when test="java:matches($asdf, $pattern1)">
      <xsl:variable name="dp" select="java:org.joda.time.format.ISODateTimeFormat.dateTimeParser()"/>

      <!--<xsl:message><xsl:value-of select="java:parseDateTime($dp, $parsed)"/></xsl:message>-->
      <xsl:variable name="f" select="java:org.joda.time.format.ISODateTimeFormat.dateTime()"/>
      <xsl:variable name="df" select="java:withZoneUTC($f)"/>
      <xsl:value-of select="java:print($df, java:parseDateTime($dp, $asdf))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message><xsl:value-of select="$parsed"/></xsl:message>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  </xsl:stylesheet>
  
