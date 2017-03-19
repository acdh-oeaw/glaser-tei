xquery version "3.0";
module namespace totei="http://www.digital-archiv.at/ns/glaser-tei/totei";
declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace templates="http://exist-db.org/xquery/templates";
import module namespace app="http://www.digital-archiv.at/ns/glaser-tei/templates" at "app.xql";
import module namespace config="http://www.digital-archiv.at/ns/glaser-tei/config" at "config.xqm";
import module namespace functx = "http://www.functx.com";

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
 : triggers a batch transformation of adlibXML to TEI-XML which will be stored in /data/imported/ and returns a list of transformed documents
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
let $text := concat('<ab type="formal-markup">', $text, '</ab>')
let $text := replace($text, '(\d+).', '<lb n="$1"/>')
let $text := replace($text, '\[', '<supplied reason="lost">' )
let $text := replace($text, '\]', '</supplied>' )
let $text := replace($text, '\(', '<unclear>')
let $text := replace($text, '\)', '</unclear>')
let $text := replace($text, '\{', '<del>')
let $text := replace($text, '\}', '</del>')
let $text := replace($text, '\.\.\.\s\.\.\.', '<gap quantity="plus4" unit="chars"></gap>')
let $tei := try{
    util:parse($text)
} catch * {
        <div type="error"><message>Caught error {$err:code}: {$err:description} in document {app:getDocName($node)}</message><text>{($text)}</text></div>
        }
return $tei
}; 

(:~
 : Takes a node containing a string encoded in the Dasi standard and removes any markup except line breaks 
 :
 : @$node a node containing a dasi-encoded string
:)
declare function totei:ToPlainText($node as node()){
let $node := $node
let $text := $node/text()
let $text := replace($text, '\|', '')
let $text := replace($text, '<', '')
let $text := replace($text, '>', '')
let $text := concat('<ab type="semantic-markup">', $text, '</ab>')
let $text := replace($text, '(\d+).', '<lb n="$1"/>')
let $text := replace($text, '\[', '' )
let $text := replace($text, '\]', '' )
let $text := replace($text, '\(', '')
let $text := replace($text, '\)', '')
let $text := replace($text, '\{', '')
let $text := replace($text, '\}', '')
let $text := replace($text, '\.\.\.\s\.\.\.', '')
let $tei := try{
    util:parse($text)
} catch * {
        <div type="error">Caught error {$err:code}: {$err:description} in document {app:getDocName($node)}</div>
        }
return $tei
}; 

(:~
 : Takes a node containing a string encoded in the Dasi standard and removes any markup except line breaks 
 :
 : @$node a node containing a dasi-encoded string
:)
declare function totei:ToPlainTextSyntax($node as node()){
let $node := $node
let $text := $node/text()
let $text := replace($text, '\|', '')
let $text := replace($text, '<', '')
let $text := replace($text, '>', '')
let $text := concat('<ab type="syntactic-markup">', $text, '</ab>')
let $text := replace($text, '(\d+).', '<lb n="$1"/>')
let $text := replace($text, '\[', '' )
let $text := replace($text, '\]', '' )
let $text := replace($text, '\(', '')
let $text := replace($text, '\)', '')
let $text := replace($text, '\{', '')
let $text := replace($text, '\}', '')
let $text := replace($text, '\.\.\.\s\.\.\.', '')
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
    for $doc in collection(concat($config:app-root, '/data/', $collection, '/'))//tei:TEI//tei:body
    let $ID := substring-before(app:getDocName($doc), '__')
    let $editionIDs := totei:storedIDs('editions')
    let $inEdition := if (not(functx:is-value-in-sequence($ID, totei:storedIDs('editions'))))
        then 
            <a href="process.html?document={app:getDocName($doc)}" onclick="return confirm('Process this document?');">process</a>
        else
            "already processed"
    let $delete := if (not(functx:is-value-in-sequence($ID, totei:storedIDs('editions'))))
        then 
            <a href="remove.html?document={app:getDocName($doc)}" onclick="return confirm('Are you sure you want to delete?');">delete</a>
        else
            "already processed"
    let $validTranslation := totei:DasiToTei($doc//tei:div[@type="edition"]/tei:ab)
    let $validTransliteration := totei:DasiToTei($doc//tei:div[@type="translation"]/tei:ab)
        return
        <tr>
            <td>
                <a href="{app:hrefToDoc($doc)}&amp;directory=imported">{app:getDocName($doc)}</a>
            </td>
            <td>{$validTranslation}
                <br/><hr/>{$validTranslation/text}
            </td>
            <td>{$validTransliteration}
                <br/><hr/>{$validTransliteration/text}
            </td>
            <td>{$delete}</td>
            <td>{$inEdition}</td>
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

(:~
 : moves and process (totei:DasiToTei and totei:ToPlainText) a document
 :)
declare function totei:processDoc($node as node(), $model as map(*)) {
if (request:get-parameter("document", "") != "") then
    let $doc := request:get-parameter("document", "")
    let $collection := concat($config:app-root, '/data/imported/')
    let $targetcollection :=concat($config:app-root, '/data/editions')
    let $movedxml := xmldb:store($targetcollection, $doc, doc(concat($collection, $doc)))
    let $transliteration := doc(concat($collection, $doc))//tei:div[@type='edition']
    let $newTransliteration  := functx:change-element-ns-deep(totei:DasiToTei($transliteration/tei:ab), "http://www.tei-c.org/ns/1.0", "tei")
    let $plainTransliteration := functx:change-element-ns-deep(totei:ToPlainText($transliteration/tei:ab), "http://www.tei-c.org/ns/1.0", "tei")
    let $syntaxTransliteration := functx:change-element-ns-deep(totei:ToPlainTextSyntax($transliteration/tei:ab), "http://www.tei-c.org/ns/1.0", "tei")
    let $translation := doc(concat($collection, $doc))//tei:div[@type='translation']
    let $newTranslation  := functx:change-element-ns-deep(totei:DasiToTei($translation/tei:ab), "http://www.tei-c.org/ns/1.0", "tei")
    let $plainTranslation  := functx:change-element-ns-deep(totei:ToPlainText($translation/tei:ab), "http://www.tei-c.org/ns/1.0", "tei")
    let $syntaxTranslation  := functx:change-element-ns-deep(totei:ToPlainTextSyntax($translation/tei:ab), "http://www.tei-c.org/ns/1.0", "tei")
    let $newTEI := update insert $newTransliteration into doc($movedxml)//tei:div[@type='edition']
    let $plainTEI := update insert $plainTransliteration into doc($movedxml)//tei:div[@type='edition']
    let $syntaxplainTEI := update insert $syntaxTransliteration into doc($movedxml)//tei:div[@type='edition']
    let $newerTEI := update insert $newTranslation into doc($movedxml)//tei:div[@type='translation']
    let $newerPlainTEI := update insert $plainTranslation into doc($movedxml)//tei:div[@type='translation']
    let $syntaxnewerPlainTEI := update insert $syntaxTranslation into doc($movedxml)//tei:div[@type='translation']
(:    let $newTEI := update replace $newnode with doc($movedxml)//tei:div[@type='edition']/tei:ab:)
    return $movedxml
else()
};
