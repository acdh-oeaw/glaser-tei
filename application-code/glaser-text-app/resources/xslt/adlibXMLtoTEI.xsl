<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0"><!-- <xsl:strip-space elements="*"/>-->
    <xsl:param name="ref"/>
    <xsl:template match="/">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Digital Edition of Glaser Abklatsch ID: <xsl:value-of select="//record/object_number"/>
                        </title>
                        <respStmt>
                            <resp>Transcribed</resp>
                            <name>PLEASE ADD NAME OF PERSON WHO transcribed THE TEXT</name>
                            <resp>Translated</resp>
                            <name>PLEASE ADD NAME OF PERSON WHO translated THE TEXT</name>
                            <resp>Annotated</resp>
                            <name>PLEASE ADD NAME OF PERSON WHO annotated THE TEXT</name>
                        </respStmt>
                    </titleStmt>
                    <publicationStmt>
                        <publisher>
                            <name>ÖAW BASIS ???</name>
                            <address>
                                <addrLine>Sonnenfelsgasse 19, 1010 Wien, Austria</addrLine>
                            </address>
                            <pubPlace>Vienna</pubPlace>
                            <date when="2016">2016</date>
                        </publisher>
                        <availability>
                            <licence target="https://creativecommons.org/licenses/by-sa/4.0/">
                                <p>
                                    Distributed under CC BY-SA 4.0 License.
                                </p>
                            </licence>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <msDesc>
                            <msIdentifier>
                                <institution>
                                    <orgName>
                                        <xsl:attribute name="key">
                                            <xsl:value-of select="//institution.name.lref"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="//record/institution.name"/>
                                    </orgName>
                                </institution>
                                <repository>
                                    <orgName>
                                        <xsl:attribute name="key">
                                            <xsl:value-of select="//part_of_reference.lref"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="//part_of_reference"/>
                                    </orgName>
                                </repository>
                                <idno>
                                    <xsl:value-of select="//part_of_reference.lref"/>
                                </idno>
                            </msIdentifier><!--<physDesc>
                                <objectDesc>
                                    <supportDesc>
                                        <extent>3</extent>
                                    </supportDesc>
                                </objectDesc>
                                <sealDesc>
                                    <seal>
                                        <decoNote>partial, illegible</decoNote>
                                    </seal>
                                </sealDesc>
                            </physDesc>-->
                        </msDesc>
                    </sourceDesc>
                </fileDesc>
                <profileDesc>
                    <creation><!--<origDate>
                            <date when="1778-08-22">22.8.1778</date>
                        </origDate>-->
                        <origPlace>
                            <settlement>
                                <placeName>
                                    <xsl:attribute name="key">
                                        <xsl:value-of select="//record/production.place.lref"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="//record/production.place"/>
                                </placeName>
                            </settlement>
                        </origPlace>
                    </creation>
                    <particDesc>
                        <listPerson xml:id="personsMentioned">
                            <head>Persons mentioned</head>
                        </listPerson>
                        <listPlace xml:id="placesMentioned">
                            <head>Placess mentioned</head>
                            <place>
                                <xsl:attribute name="xml:id">
                                    <xsl:value-of select="concat('adlib_id', //record/production.place.lref)"/>
                                </xsl:attribute>
                                <placeName>
                                    <xsl:value-of select="//record/production.place"/>
                                </placeName>
                                <idno type="geonames">
                                    <xsl:value-of select="//record/production.place.uri"/>
                                </idno>
                            </place>
                        </listPlace>
                    </particDesc>
                    <abstract xml:lang="en">
                        <p>abstract</p>
                    </abstract>
                    <langUsage>
                        <language ident="fr"/>
                    </langUsage>
                </profileDesc>
                <revisionDesc>
                    <xsl:for-each select="//edit.date">
                        <change>
                            <xsl:attribute name="when">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                            <xsl:attribute name="who">
                                <xsl:value-of select="following::edit.name[1]"/>
                            </xsl:attribute>
                        </change>
                    </xsl:for-each>
                </revisionDesc>
            </teiHeader>
            <text>
                <body>
                    <div type="original">
                        <xsl:value-of select="//inscription.transliteration"/>
                    </div>
                    <div type="translation">
                        <xsl:value-of select="//inscription.translation"/>
                    </div>
                </body>
            </text>
        </TEI>
    </xsl:template>
</xsl:stylesheet>