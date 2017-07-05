xquery version "3.1";

declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/glaser-tei/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/glaser-tei/templates" at "../modules/app.xql";
import module namespace totei="http://www.digital-archiv.at/ns/glaser-tei/totei" at "../modules/totei.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(:some test:)

for $resource in xmldb:get-child-resources($config:app-root||"/data/done/")
let $newname := substring-before($resource, '__')||".xml"
let $renamed := xmldb:rename($config:app-root||"/data/done/", $resource, $newname)
    return
        $newname