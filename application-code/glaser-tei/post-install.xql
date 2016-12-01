xquery version "3.0";

import module namespace xdb="http://exist-db.org/xquery/xmldb";

import module namespace config="http://www.digital-archiv.at/ns/glaser-tei/config" at "modules/config.xqm";

(: The following external variables are set by the repo:deploy function :)

(: file path pointing to the exist installation directory :)
declare variable $home external;
(: path to the directory containing the unpacked .xar package :)
declare variable $dir external;
(: the target collection into which the app is deployed :)
declare variable $target external;

declare function local:mkcol-recursive($collection, $components) {
    if (exists($components)) then
        let $newColl := concat($collection, "/", $components[1])
        return (
            xdb:create-collection($collection, $components[1]),
            local:mkcol-recursive($newColl, subsequence($components, 2))
        )
    else
        ()
};

(: Helper function to recursively create a collection hierarchy. :)
declare function local:mkcol($collection, $path) {
    local:mkcol-recursive($collection, tokenize($path, "/"))
};


(: create 'glaser' group :)
if (not(sm:group-exists("glaser")))
then sm:create-group("glaser")
else (),


(: grant 'read' and 'execute' permissions on restxq endpoint module to editors and annotators :)
sm:add-group-ace(xs:anyURI($config:app-root||"/modules/app.xql"), "glaser", true(), "r-x"),
sm:add-group-ace(xs:anyURI($config:app-root||"/modules/totei.xql"), "glaser", true(), "r-x"),
sm:add-group-ace(xs:anyURI($config:app-root||"/modules/validates.xql"), "glaser", true(), "r-x"),
sm:add-group-ace(xs:anyURI($config:app-root||"/modules/functx.xql"), "glaser", true(), "r-x"),

(: grant all rights to all documents to 'glaser' group:)

for $collection in xmldb:get-child-collections($config:app-root||"/data")
    let $changed := sm:add-group-ace(xs:anyURI($config:app-root||"/data/"||$collection), "glaser", true(), "rwx")
    for $resource in xmldb:get-child-resources(xs:anyURI($config:app-root||"/data/"||$collection))
        return
            sm:add-group-ace(xs:anyURI($config:app-root||"/data/"||$collection||"/"||$resource), "glaser", true(), "rwx")