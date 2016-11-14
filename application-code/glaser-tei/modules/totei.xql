xquery version "3.0";
module namespace totei="http://www.digital-archiv.at/ns/glaser-tei/totei";

import module namespace templates="http://exist-db.org/xquery/templates";
import module namespace app="http://www.digital-archiv.at/ns/glaser-tei/templates" at "app.xql";
import module namespace config="http://www.digital-archiv.at/ns/glaser-tei/config" at "config.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace functx = 'http://www.functx.com';

declare function functx:is-value-in-sequence
  ( $value as xs:anyAtomicType? ,
    $seq as xs:anyAtomicType* )  as xs:boolean {

   $value = $seq
 } ;

(:~
 : Returns a list of adlib ID of documents stored in the passed in collection. 
:)
declare function totei:storedIDs($collection as xs:string){
for $doc in collection(concat($config:app-root, '/data/', $collection, '/'))//tei:TEI
let $ID := substring-before(app:getDocName($doc), '__')
return
    $ID
};

(:~
 : Returns a list of adlib ID. 
:)
declare function totei:getIDs(){
let $uri := "http://opacbasis.w07adlib1.arz.oeaw.ac.at/wwwopac.ashx?database=archive&amp;command=getpointerfile&amp;number=15"
let $xml := doc($uri)
let $ids := $xml//hit/text() 
let $countIds := count($ids)
let $result := <items>
        {for $x in $ids where not(functx:is-value-in-sequence($x, totei:storedIDs('imported')))
        return 
            <hit>{$x}</hit>}          
    </items>
let $amount := count($result//hit)
return <result><amount>{$amount}</amount>{$result}</result>
};

(:~
 : Returns a single adlibXML document
 :
 : @param $id takes an adlib Identifier as string 
 
:)
declare function totei:getAdlibXML($id as xs:string){
let $base := "http://opacbasis.w07adlib1.arz.oeaw.ac.at/wwwopac.ashx?action=search&amp;database=archive&amp;search=priref="
let $uri := concat($base, $id)
return $uri
};



(:~
 : triggers a batch transformation of adlibXML to TEI-XML which will be stored in /data/editions/ and returns a list of transformed documents
 :)
declare function totei:triggerBatchTrans($node as node(), $model as map(*)) {
if (request:get-parameter("update", "") = "yes") then
<ul class="list-unstyled">
{
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
let $time := replace(xs:string(current-dateTime()), '[:+/.]', '-')
let $filename := concat($x,'__', $time, '.xml')
let $storedirectory := concat($config:app-root, '/data/imported/')
let $store := xmldb:store(concat($config:app-root, '/data/imported/'), $filename, $tei)
return
    <li>
        <a href="show.html?document={$filename}&amp;directory=imported">{$filename}</a>
    </li>
}
</ul>
else
<p>Hit the button to import texts from adlib</p>
};