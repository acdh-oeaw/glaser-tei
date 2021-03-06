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
                        <title type="alt">
                            <xsl:value-of select="//priref"/>
                        </title>
                        <title type="alt">
                            <xsl:value-of select="//record/object_number"/>
                        </title>
                        <respStmt>
                            <persName>
                                <forename>Dummy Forename</forename>
                                <surname>Dummy Lastname</surname>
                            </persName>
                            <resp>What was this person doing?</resp>
                        </respStmt>
                    </titleStmt>
                    <publicationStmt>
                        <authority>ÖAW BASIS</authority>
                        <availability>
                            <licence target="#">Some license information</licence>
                        </availability>
                        <idno type="idRecord">
                            <xsl:value-of select="//record/object_number"/>
                        </idno>
                    </publicationStmt>
                    <sourceDesc>
                        <msDesc>
                            <msIdentifier>
                                <settlement>Wien</settlement>
                                <repository>ÖAW Basis</repository>
                                <collection>name of the collection </collection>
                                <idno type="invNo">Inventory nummber of the source</idno>
                            </msIdentifier>
                            <msContents>
                                <summary>
                                    <rs type="alphabet">Ancient South Arabian</rs>
                                    <seg>Inscription commissioned by a king</seg>
                                </summary>
                            </msContents>
                            <physDesc>
                                <objectDesc>
                                    <supportDesc>
                                        <support>
                                            <objectType>Stone inscription</objectType>
                                            <material>Stone</material>
                                            <measureGrp unit="cm">h. 25, w. 57, th. 11.4</measureGrp>
                                        </support>
                                    </supportDesc>
                                    <layoutDesc>
                                        <layout>
                                            <rs type="scriptCursus">Right to left</rs>
                                            <rs type="execution">Incision</rs>
                                        </layout>
                                    </layoutDesc>
                                </objectDesc>
                                <handDesc>
                                    <handNote>
                                        <height unit="cm"/>
                                        <rs type="scriptTypology">Monumental writing</rs>
                                        <rs type="textualTypology">Legal text</rs>
                                    </handNote>
                                </handDesc>
                                <additions>
                                    <note/>
                                    <note type="support"/>
                                    <note type="deposit"/>
                                </additions>
                            </physDesc>
                            <history>
                                <origin>
                                    <origPlace/>
                                    <origDate period="#B"/>
                                    <note/>
                                </origin>
                                <provenance type="found">
                                    <placeName type="modern" subtype="site">as-Sawdāʾ</placeName>
                                    <placeName subtype="site" type="ancient">Ns²n</placeName>
                                    <placeName subtype="geographicalArea" type="modern">wādī al-Jawf</placeName>
                                    <placeName type="modern" subtype="country">Yemen</placeName>
                                    <seg type="proximity"/>
                                    <seg type="archaeologicalContext">
                                        <rs type="context"/>
                                        <rs type="structure"/>
                                    </seg>
                                </provenance>
                            </history>
                        </msDesc>
                    </sourceDesc>
                </fileDesc>
                <profileDesc>
                    <langUsage>
                        <language ident="en">English</language>
                        <language ident="inm-Latn-x-cntmin">Central Minaic</language>
                    </langUsage>
                    <textClass>
                        <keywords scheme="#DASI">
                            <list>
                                <label>Periodization</label>
                                <item>
                                    <term xml:id="A">Early first millennium to the fourth century BC (predominance of Saba)</term>
                                    <term xml:id="B">Fourth to first centuries BC (predominance of Qataban and Hadramawt, and their alliance with Main)</term>
                                    <term xml:id="B1">Fourth to third centuries BC</term>
                                    <term xml:id="B2">Third to first centuries BC</term>
                                    <term xml:id="C">First century BC to early second century AD (alliances between the tribes of the high plateau and the ASA kingdoms)</term>
                                    <term xml:id="D">Late second to late third centuries AD (wars among the Himyar, Saba and Hadramawt)</term>
                                    <term xml:id="E">Fourth to sixth centuries AD (unification of Yemen under Himyarite rule)</term>
                                    <term xml:id="Ry">It corresponds to the palaeographical divisions established by Jacques Ryckmans with sub-periods I-IV</term>
                                    <term xml:id="RyI">First sub-period of the palaeographical divisions established by Jacques Ryckmans</term>
                                    <term xml:id="RyII">Second sub-period of the palaeographical divisions established by Jacques Ryckmans</term>
                                    <term xml:id="RyIIb">Second sub-period of the palaeographical divisions established by Jacques Ryckmans</term>
                                    <term xml:id="RyIId">Second sub-period of the palaeographical divisions established by Jacques Ryckmans</term>
                                    <term xml:id="RyIIIa">Third sub-period of the palaeographical divisions established by Jacques Ryckmans</term>
                                    <term xml:id="RyIVa">Fourth sub-period of the palaeographical divisions established by Jacques Ryckmans</term>
                                    <term xml:id="RyIVb">Fourth sub-period of the palaeographical divisions established by Jacques Ryckmans</term>
                                    <term xml:id="inAncientTimes"/>
                                    <term xml:id="inModernTimes"/>
                                </item>
                            </list>
                        </keywords>
                    </textClass>
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
            <facsimile>
                <graphic url="http://dasi.humnet.unipi.it/de/cgi-bin/wsimg.pl?recId=6938">
                    <desc type="copyright">By kind permission of British Museum</desc>
                </graphic>
            </facsimile>
            <text>
                <body>
                    <div xml:lang="inm-Latn-x-cntmin" type="edition">
                        <tei:ab type="adlib-orig">
                            <xsl:value-of select="//inscription.transliteration"/>
                        </tei:ab>
                    </div>
                    <div xml:lang="en" type="translation">
                        <tei:ab type="adlib-orig">
                            <xsl:value-of select="//inscription.translation"/>
                        </tei:ab>
                    </div>
                    <div type="commentary">
                        <p/>
                    </div>
                    <div type="bibliography">
                        <listBibl>
                            <bibl>
                                <idno type="quotationLabel">Avanzini 1995</idno>
                                <seg type="reference">Avanzini, Alessandra 1995. As-Sawdāʾ. Inventaire des inscriptions sudarabiques. 4. Paris: de Boccard / Rome: Herder. [Académie des Inscriptions et Belles-lettres; Istituto italiano per l'Africa e l'Oriente]</seg>
                                <citedRange>120-122, pl. 19/a</citedRange>
                            </bibl>
                        </listBibl>
                    </div>
                </body>
            </text>
        </TEI>
    </xsl:template>
</xsl:stylesheet>