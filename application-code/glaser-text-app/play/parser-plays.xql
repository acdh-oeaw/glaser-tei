xquery version "3.1";

declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/glaser/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/glaser/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $doc := doc($config:app-root||'/data/editions/1110000005__15-23-14-311-02-00.xml')
let $orig := $doc//tei:div[@type='original']/text()
let $lb_orig := replace($orig, '(\d).', '<lb n="$1"/>')
let $supplied := replace($lb_orig, '\[', 'XXXXXXXX' )
let $supplied := replace($supplied, '\]', 'YYYYYYY' )
return $supplied