xquery version "3.1";
import module namespace app="http://www.digital-archiv.at/ns/glaser-tei/templates" at "../modules/app.xql";
import module namespace config="http://www.digital-archiv.at/ns/glaser-tei/config" at "modules/config.xqm";

import module namespace util="http://exist-db.org/xquery/util";

declare namespace expath="http://expath.org/ns/pkg";
declare namespace repo="http://exist-db.org/xquery/repo";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare option exist:serialize "method=json media-type=text/javascript content-type=application/json";

let $letter := request:get-parameter('letter', false())
let $words := if ($letter) then collection($app:done)//tei:ab[@type="semantic-markup"]//tei:w[starts-with(./text(), $letter)] else collection($app:done)//tei:ab[@type="semantic-markup"]//tei:w
let $amount := count($words)

let $data := 
<data>
{
    for $x in $words
        let $doc := util:document-name($x)
        let $text := normalize-space(string-join($x/text()))
        order by $text
        group by $text
        return 
            <item>
                <text>{$text[1]}</text>
                <occurences>{count($doc)}</occurences>
                <doc>{distinct-values($doc)}</doc>
            </item>
}
</data>
    return
    <result>
        <tokens>{$amount}</tokens>
        <types>{count($data/item)}</types>
        {$data}
    </result>