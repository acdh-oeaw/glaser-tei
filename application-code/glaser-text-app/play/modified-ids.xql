xquery version "3.1";

declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/glaser/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/glaser/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "xml";
declare option output:media-type "text/xml";

let $resultlist := app:getIDs('2016-08-01', '10')
for $x in $resultlist//priref/text()
let $adlibXML := doc(app:getAdlibXML($x))
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
let $filename := concat($x, '.xml')
let $store := xmldb:store(concat($config:app-root, '/data/editions/'), $filename, $tei)

return
    "$adlibXML"
