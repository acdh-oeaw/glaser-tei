xquery version "3.1";

declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/glaser-tei/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/glaser-tei/templates" at "../modules/app.xql";
import module namespace totei="http://www.digital-archiv.at/ns/glaser-tei/totei" at "../modules/totei.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $resultlist := totei:getIDs()
for $x in $resultlist//hit/text()
    let $adlibXML := doc(totei:getAdlibXML($x))
    let $params := <parameters>
       {for $p in request:get-parameter-names()
        let $val := request:get-parameter($p,())
        where  not($p = ("document","directory","xslt"))
        return
           <param name="{$p}"  value="{$val}"/>
       }
    </parameters>
    
    let $xsl := doc(concat($config:app-root, '/resources/xslt/adlibXMLtoTEI.xsl'))
    let $tei := transform:transform($adlibXML, $xsl, $params)
    let $filename := $x||'.xml'
    let $storedirectory := concat($config:app-root, '/data/imported/')
    let $store := xmldb:store(concat($config:app-root, '/data/imported/'), $filename, $tei)
    return
        <li>
            <a href="show.html?document={$filename}&amp;directory=imported">{$filename}</a>
        </li>
