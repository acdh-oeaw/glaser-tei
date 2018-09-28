<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0"><!-- <xsl:strip-space elements="*"/>-->
    <xsl:import href="shared/base.xsl"/>
    <xsl:param name="document"/>
    <xsl:param name="app-name"/>
    <xsl:param name="collection-name"/>
    <xsl:param name="path2source"/>
    <xsl:param name="ref"/>
    <xsl:param name="prev"/>
    <xsl:param name="next"/>
    <xsl:template match="/">
        <div class="card">
            <div class="card-header" align="center">
                <h2>
                    <xsl:apply-templates select=".//tei:title[@type='sub']"/>
                </h2>
                <h4>by<br/>
                    <xsl:for-each select="//tei:titleStmt//tei:author//tei:persName">
                        <xsl:apply-templates select="."/>
                        <br/>
                    </xsl:for-each>
                </h4>
            </div>
            <div class="card-body">
                <xsl:apply-templates select="//tei:text"/>
            </div>
                <div class="card-footer">
                    <p style="text-align:center;">
                        <xsl:for-each select="tei:TEI/tei:text/tei:body//tei:note">
                                <div class="footnotes">
                                    <xsl:element name="a">
                                        <xsl:attribute name="name">
                                            <xsl:text>fn</xsl:text>
                                            <xsl:number level="any" format="1" count="tei:note"/>
                                        </xsl:attribute>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:text>#fna_</xsl:text>
                                                <xsl:number level="any" format="1" count="tei:note"/>
                                            </xsl:attribute>
                                            <span style="font-size:7pt;vertical-align:super;">
                                                <xsl:number level="any" format="1" count="tei:note"/>
                                            </span>
                                        </a>
                                    </xsl:element>
                                    <xsl:choose>
                                        <xsl:when test=".//tei:ptr">
                                            <xsl:for-each select=".//tei:ptr">
                                                <xsl:variable name="selctedID">
                                                    <xsl:value-of select="substring-after(data(./@target),'#')"/>
                                                </xsl:variable>
                                                <xsl:variable name="selectedBook">
                                                    <xsl:value-of select="ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]"/>
                                                </xsl:variable>
                                                <xsl:choose>
                                                    <xsl:when test="ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]//tei:persName">
                                                        <xsl:value-of select=" string-join(ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]//tei:surname, '/')"/>,
                                                        <xsl:value-of select="ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]//tei:date[1]"/>
                                                        <xsl:apply-templates/>
                                                        <xsl:if test="position() &lt; last()">; </xsl:if>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select=" string-join(ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]//tei:author, '/')"/>,
                                                        <xsl:value-of select="ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]//tei:date[1]"/>
                                                        <xsl:apply-templates/>
                                                        <xsl:if test="position() &lt; last()">; </xsl:if>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="."/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </div>
                            </xsl:for-each>
                    </p>
                    <p style="text-align:center;">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="$path2source"/>
                            </xsl:attribute>
                            see the TEI source of this document
                        </a>
                    </p>
                </div>
            </div>

        
        
        
    </xsl:template><!--
    #####################
    ###  Formatierung ###
    #####################
-->
    
</xsl:stylesheet>