xquery version "3.1";
import module namespace app="http://www.digital-archiv.at/ns/glaser-tei/templates" at "../modules/app.xql";
import module namespace config="http://www.digital-archiv.at/ns/glaser-tei/config" at "modules/config.xqm";

import module namespace util="http://exist-db.org/xquery/util";

declare namespace expath="http://expath.org/ns/pkg";
declare namespace repo="http://exist-db.org/xquery/repo";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare option exist:serialize "method=json media-type=application/json content-type=application/json";

let $entType := request:get-parameter('entType', 'ame')
let $mentions := collection($app:done)//tei:ab//*[ends-with(name(), $entType)]
let $amount := count($mentions)
let $data :=
<data>
    {
    for $x in $mentions
        let $text : = normalize-space(string-join($x//text(), ' '))
        let $maintype := name($x)
        let $type := if ($x/@type) then data($x/@type) else 'not specified'
        let $subtype := if ($x/@subtype) then data($x/@subtype) else 'not specified'
        let $doc := util:document-name($x)
        group by $text
        order by $text
        return
            <item>
                <text>{$text}</text>
                <occurences>{count($type)}</occurences>
                <maintype>{$maintype[1]}</maintype>
                <type>{$type[1]}</type>
                <subtype>{$subtype[1]}</subtype>
                <doc>{$doc}</doc>
            </item>
    }

</data>

return
    <result>
        <hits>{$amount}</hits>
        {$data}
    </result>
