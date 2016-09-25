xquery version "3.1";

declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/glaser/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/glaser/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare function functx:change-element-ns-deep
  ( $nodes as node()* ,
    $newns as xs:string ,
    $prefix as xs:string )  as node()* {

  for $node in $nodes
  return if ($node instance of element())
         then (element
               {QName ($newns,
                          concat($prefix,
                                    if ($prefix = '')
                                    then ''
                                    else ':',
                                    local-name($node)))}
               {$node/@*,
                functx:change-element-ns-deep($node/node(),
                                           $newns, $prefix)})
         else if ($node instance of document-node())
         then functx:change-element-ns-deep($node/node(),
                                           $newns, $prefix)
         else $node
 } ;

declare option output:method "xml";
declare option output:media-type "text/xml";
<try>{
for $doc in collection(concat($config:app-root, '/data/sample-data'))//tei:div[@type='original']
let $text := replace($doc, '<', '<add>')
let $text := replace($text, '>', '</add>')
let $text := concat('<div>', $text, '</div>')
let $text := replace($text, '(\d).', '<lb n="$1"/>')
let $text := replace($text, '\[', '<supplied>' )
let $text := replace($text, '\]', '</supplied>' )
let $text := replace($text, '\(', '<unclear>')
let $text := replace($text, '\)', '</unclear>')
let $text := replace($text, '\{', '<del>')
let $text := replace($text, '\}', '</del>')
let $text := replace($text, '\.\.\.\s\.\.\.', '<gap quantity="plus4" unit="chars"></gap>')

let $nodes := try{
    util:parse($text)
} catch * {
        <error>Caught error {$err:code}: {$err:description} in document {app:getDocName($doc)}</error>
        }
return 
    functx:change-element-ns-deep($nodes, "http://www.tei-c.org/ns/1.0", "tei")
}
</try>