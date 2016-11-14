xquery version "3.1";

declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/glaser-tei/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/glaser-tei/templates" at "../modules/app.xql";
import module namespace totei="http://www.digital-archiv.at/ns/glaser-tei/totei" at "../modules/totei.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";


declare function functx:is-value-in-sequence
  ( $value as xs:anyAtomicType? ,
    $seq as xs:anyAtomicType* )  as xs:boolean {

   $value = $seq
 } ;




let $uri := "http://opacbasis.w07adlib1.arz.oeaw.ac.at/wwwopac.ashx?database=archive&amp;command=getpointerfile&amp;number=15"
let $xml := doc($uri)
let $ids := $xml//hit/text() 
let $countIds := count($ids)
let $result := <items>
        {for $x in $ids where not(functx:is-value-in-sequence($x, totei:storedIDs('imported')))
        return 
            <hit>{$x}</hit>}          
    </items>
let $amount = count($result//hit)
return $amount

