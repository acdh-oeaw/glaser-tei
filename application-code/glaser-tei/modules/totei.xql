xquery version "3.0";
module namespace totei="http://www.digital-archiv.at/ns/glaser-tei/totei";
declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace templates="http://exist-db.org/xquery/templates";
import module namespace app="http://www.digital-archiv.at/ns/glaser-tei/templates" at "app.xql";
import module namespace config="http://www.digital-archiv.at/ns/glaser-tei/config" at "config.xqm";
import module namespace functx="http://www.functx.com" at "functx.xql";

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

(:~
 : Takes a node containing a string encoded in the Dasi standard and returns a TEI encoded node 
 :
 : @$node a node containing a dasi-encoded string
:)
declare function totei:DasiToTei($node as node()){
let $node := $node
let $text := $node/text()
let $text := replace($text, '<', '<add>')
let $text := replace($text, '>', '</add>')
let $text := concat('<div type="annotated">', $text, '</div>')
let $text := replace($text, '(\d).', '<lb n="$1"/>')
let $text := replace($text, '\[', '<supplied>' )
let $text := replace($text, '\]', '</supplied>' )
let $text := replace($text, '\(', '<unclear>')
let $text := replace($text, '\)', '</unclear>')
let $text := replace($text, '\{', '<del>')
let $text := replace($text, '\}', '</del>')
let $text := replace($text, '\.\.\.\s\.\.\.', '<gap quantity="plus4" unit="chars"></gap>')
let $tei := try{
    util:parse($text)
} catch * {
        <div type="error">Caught error {$err:code}: {$err:description} in document {app:getDocName($node)}</div>
        }
return $tei
}; 

(:~
 : checks if imported documents could be enhanced automatically
 :)
declare function totei:check-valid($node as node(), $model as map(*)) {
    let $collection := request:get-parameter("collection", "imported")
    for $doc in collection(concat($config:app-root, '/data/', $collection, '/'))//tei:TEI//tei:div[@type='edition']/tei:ab
    let $valid := totei:DasiToTei($doc)
        return
        <tr>
            <td>
                <a href="{app:hrefToDoc($doc)}&amp;directory=imported">{app:getDocName($doc)}</a>
            </td>
            <td>{$valid}</td>
            <td><a href="remove.html?document={app:getDocName($doc)}" onclick="return confirm('Are you sure you want to delete?');">delete</a></td>
            <td><a href="www.derstandard.at" onclick="return confirm('Are you sure you want to delete?');">upgrade</a></td>
        </tr>   
};

(:~
 : removes a document
 :)
declare function totei:removeDoc($node as node(), $model as map(*)) {
if (request:get-parameter("document", "") != "") then
    let $doc := request:get-parameter("document", "")
    let $collection := concat($config:app-root, '/data/imported/')
    let $removed :=xmldb:remove($collection, $doc)
    return $doc
else()
};
