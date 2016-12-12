xquery version "3.0";
module namespace app="http://www.digital-archiv.at/ns/glaser-tei/templates";
declare namespace tei="http://www.tei-c.org/ns/1.0";
import module namespace functx="http://www.functx.com" at "functx.xql";
import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://www.digital-archiv.at/ns/glaser-tei/config" at "config.xqm";
import module namespace totei="http://www.digital-archiv.at/ns/glaser-tei/totei" at "totei.xql";
import module namespace kwic = "http://exist-db.org/xquery/kwic" at "resource:org/exist/xquery/lib/kwic.xql";



(:~
 : This is a sample templating function. It will be called by the templating module if
 : it encounters an HTML element with an attribute data-template="app:test" 
 : or class="app:test" (deprecated). The function has to take at least 2 default
 : parameters. Additional parameters will be mapped to matching request or session parameters.
 : 
 : @param $node the HTML node with the attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)
declare function app:test($node as node(), $model as map(*)) {
    <p>Dummy template output generated by function app:test at {current-dateTime()}. The templating
        function was triggered by the data-template attribute <code>data-template="app:test"</code>.</p>
};

(:~
: logs a user in.
:)
declare function app:logIn($node as node(), $model as map(*)){
<p>test</p>
};

(:~
: returns the name of the document of the node passed to this function.
:)
declare function app:getDocName($node as node()){
let $name := functx:substring-after-last(document-uri(root($node)), '/')
    return $name
};

(:~
 : href to document.
 :)
declare function app:hrefToDoc($node as node()){
let $name := functx:substring-after-last($node, '/')
let $href := concat('show.html','?document=', app:getDocName($node))
    return $href
};

(:~
 : href to document.
 :)
declare function app:hrefToDoc($node as node(), $stylesheet as xs:string){
let $name := functx:substring-after-last($node, '/')
let $href := if ($stylesheet != "") 
    then
        concat('show.html','?document=', app:getDocName($node), '&amp;xslt=', $stylesheet)
     else
        concat('show.html','?document=', app:getDocName($node))
    return $href
};

(:~
 : a fulltext-search function
 :)
 declare function app:ft_search($node as node(), $model as map (*)) {
 if (request:get-parameter("searchexpr", "") !="") then
 let $searchterm as xs:string:= request:get-parameter("searchexpr", "")
 for $hit in collection(concat($config:app-root, '/data/editions/'))//*[.//tei:p[ft:query(.,$searchterm)]|.//tei:cell[ft:query(.,$searchterm)]]
    let $href := concat(app:hrefToDoc($hit), "&amp;searchexpr=", $searchterm) 
    let $score as xs:float := ft:score($hit)
    order by $score descending
    return
    <tr>
        <td>{$score}</td>
        <td class="KWIC">{kwic:summarize($hit, <config width="40" link="{$href}" />)}</td>
        <td>{app:getDocName($hit)}</td>
    </tr>
 else
    <div>Nothing to search for</div>
 };

(:~
 : fetches all documents which contain the searched entity
 :)
declare function app:registerBasedSearch_hits($node as node(), $model as map(*), $searchkey as xs:string?, $path as xs:string?)
{
for $title in collection(concat($config:app-root, '/data/'))//tei:TEI[.//*[@key=$searchkey] | .//*[@ref=concat("#",$searchkey)] | .//tei:abbr[text()=$searchkey]]
    let $doc := document-uri(root($title))
    let $type := tokenize($doc,'/')[(last() - 1)]
    let $params := concat("&amp;directory=", $type, "&amp;stylesheet=", $type)
    let $matchingdoc := root($title)//tei:abbr[text()=$searchkey] | root($title)//*[@key=$searchkey] |  root($title)//*[@ref=concat("#",$searchkey)]
    let $hits := count($matchingdoc)
    let $snippet := 
        for $context in $matchingdoc
        let $before := $context/preceding::text()[1]
        let $after := $context/following::text()[1]
        return
            <p>... {$before} <strong><a href="{concat(app:hrefToDoc($title), $params)}"> {$context/text()}</a></strong> {$after}...<br/></p>
    order by -$hits
    return
    <tr>
        <td>{$hits}</td>
        <td class="KWIC">{$snippet}</td>
        <td>
            <a href="{concat(app:hrefToDoc($title),$params)}">{app:getDocName($title)}</a>
        </td>
    </tr> 
 };
  
 (:~
 : creates a basic organisation-index derived from the  '/data/indices/listorg.xml'
 :)
declare function app:listOrg($node as node(), $model as map(*)) {
    let $hitHtml := "hits.html?searchkey="
    for $org in doc(concat($config:app-root, '/data/indices/listorg.xml'))//tei:listOrg/tei:org
        return
        <tr>
            <td>
                <a href="{concat($hitHtml,data($org/@xml:id))}">{$org/tei:orgName}</a>
            </td>
        </tr>
};
 
(:~
 : creates a basic bibl-index derived from the  '/data/indices/listbibl.xml'
 :)
declare function app:listBibl($node as node(), $model as map(*)) {
    let $hitHtml := "hits.html?searchkey="
    for $bibl in doc(concat($config:app-root, '/data/indices/listbibl.xml'))//tei:item
        return
        <tr>
            <td>
                <a href="{concat($hitHtml,$bibl/tei:label)}">{$bibl}</a>
            </td>
        </tr>
};
 
(:~
 : creates a basic place-index derived from the  '/data/indices/listplace.xml'
 :)
declare function app:listPlace($node as node(), $model as map(*)) {
    let $hitHtml := "hits.html?searchkey="
    for $place in doc(concat($config:app-root, '/data/indices/listplace.xml'))//tei:listPlace/tei:place
        return
        <tr>
            <td>
                <a href="{concat($hitHtml,data($place/@xml:id))}">{$place/tei:placeName}</a>
            </td>
        </tr>
};
 
(:~
 : creates a basic person-index derived from the  '/data/indices/listperson.xml'
 :)
declare function app:listPers($node as node(), $model as map(*)) {
    let $hitHtml := "hits.html?searchkey="
    for $person in doc(concat($config:app-root, '/data/indices/listperson.xml'))//tei:listPerson/tei:person
        return
        <tr>
            <td>
                <a href="{concat($hitHtml,data($person/@xml:id))}">{$person/tei:persName}</a>
            </td>
        </tr>
};

(:~
 : creates a basic table of content derived from the documents stored in '/data/editions'
 :)
declare function app:toc($node as node(), $model as map(*)) {
    let $collection := request:get-parameter("collection", "editions")
    for $doc in collection(concat($config:app-root, '/data/', $collection, '/'))//tei:TEI
        return
        <tr>
            <td>
                <a href="{concat(app:hrefToDoc($doc),'&amp;directory=',$collection)}">{app:getDocName($doc)}</a>
            </td>
        </tr>   
};

(:~
 : creates a basic table of content and checks the progress of each document
 :)
declare function app:checkProgress($node as node(), $model as map(*)) {
    let $collection := request:get-parameter("collection", "editions")
    for $doc in collection(concat($config:app-root, '/data/', $collection, '/'))//tei:TEI
    let $ID := substring-before(app:getDocName($doc), '__')
    let $editionIDs := totei:storedIDs('editions')
    let $doneIDs := totei:storedIDs('done')
    let $inEdition := if (functx:is-value-in-sequence($ID, totei:storedIDs('editions')))
        then 
            <a href="{concat(app:hrefToDoc($doc),'&amp;directory=editions')}">
                <span class="glyphicon glyphicon-ok" aria-hidden="true"><span style="visibility:hidden">yes</span></span>
            </a>
        else
            <span class="glyphicon glyphicon-remove" aria-hidden="true"><span style="visibility:hidden">no</span></span> 
    
    let $inDone := if (functx:is-value-in-sequence($ID, totei:storedIDs('done')))
         then
            <a href="{concat(app:hrefToDoc($doc),'&amp;directory=done')}">
                <span class="glyphicon glyphicon-ok" aria-hidden="true"><span style="visibility:hidden">yes</span></span>
            </a>
        else
            <span class="glyphicon glyphicon-remove" aria-hidden="true"><span style="visibility:hidden">no</span></span> 
        
    
        return
        <tr>
            <td>
                <a href="{concat(app:hrefToDoc($doc),'&amp;directory=',$collection)}">{app:getDocName($doc)}</a>
            </td>
            <td>
                {$inEdition}
            </td>
            <td>
                {$inDone}
            </td>
        </tr>   
};

(:~
 : perfoms an XSLT transformation
:)
declare function app:XMLtoHTML ($node as node(), $model as map (*), $query as xs:string?) {
let $ref := xs:string(request:get-parameter("document", ""))
let $xmlPath := concat(xs:string(request:get-parameter("directory", "editions")), '/')
let $xml := doc(replace(concat($config:app-root,'/data/', $xmlPath, $ref), '/exist/', '/db/'))
let $xslPath := concat(xs:string(request:get-parameter("stylesheet", "editions")), '.xsl')
let $xsl := doc(replace(concat($config:app-root,'/resources/xslt/', $xslPath), '/exist/', '/db/'))
let $params := 
<parameters>
   {for $p in request:get-parameter-names()
    let $val := request:get-parameter($p,())
    (:where  not($p = ("document","directory","stylesheet")):)
    return
       <param name="{$p}"  value="{$val}"/>
   }
</parameters>
return 
    transform:transform($xml, $xsl, $params)
};