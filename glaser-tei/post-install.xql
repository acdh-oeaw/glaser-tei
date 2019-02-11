xquery version "3.0";
import module namespace config="http://www.digital-archiv.at/ns/glaser-tei/config" at "modules/config.xqm";

for $resource in xmldb:get-child-resources(xs:anyURI($config:app-root||"/modules/"))
    return sm:chmod(xs:anyURI($config:app-root||'/modules/'||$resource), "rwxrwxr-x"),
for $resource in xmldb:get-child-resources(xs:anyURI($config:app-root||"/analyze/"))
    return sm:chmod(xs:anyURI($config:app-root||'/analyze/'||$resource), "rwxrwxr-x"),
for $resource in xmldb:get-child-resources(xs:anyURI($config:app-root||"/api/"))
    return sm:chmod(xs:anyURI($config:app-root||'/api/'||$resource), "rwxrwxr-x")
