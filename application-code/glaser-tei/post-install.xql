xquery version "3.0";
import module namespace config="http://www.digital-archiv.at/ns/glaser-tei/config" at "modules/config.xqm";

declare variable $app-user := "glaser-tei";

(: create 'glaser' group :)
if (not(sm:group-exists($app-user)))
then sm:create-group($app-user)
else (),

(: grant 'read' and 'execute' permissions on restxq endpoint module to editors and annotators :)
sm:chmod(xs:anyURI($config:app-root||"/modules/api.xqm"), "rwxrwxr-x"),

(: grant 'read' and 'execute' permissions on xquery modules to editors and annotators :)
sm:add-group-ace(xs:anyURI($config:app-root||"/modules/app.xql"), $app-user, true(), "r-x"),
sm:add-group-ace(xs:anyURI($config:app-root||"/modules/totei.xql"), $app-user, true(), "r-x"),
sm:add-group-ace(xs:anyURI($config:app-root||"/modules/validates.xql"), $app-user, true(), "r-x"),
sm:add-group-ace(xs:anyURI($config:app-root||"/modules/functx.xql"), $app-user, true(), "r-x"),

(: remove access rights to import-documents-check.html for guest user :)
sm:chmod(xs:anyURI($config:app-root||"/pages/import-documents-check.html"), "rw-rw----"),

(: grant all rights to all documents to 'glaser' group:)

for $collection in xmldb:get-child-collections($config:app-root||"/data")
    let $changed := sm:add-group-ace(xs:anyURI($config:app-root||"/data/"||$collection), $app-user, true(), "rwx")
    for $resource in xmldb:get-child-resources(xs:anyURI($config:app-root||"/data/"||$collection))
        return
            sm:add-group-ace(xs:anyURI($config:app-root||"/data/"||$collection||"/"||$resource), $app-user, true(), "rwx")