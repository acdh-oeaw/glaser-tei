xquery version "3.0";

declare namespace expath="http://expath.org/ns/pkg";
declare namespace repo="http://exist-db.org/xquery/repo";

import module namespace config="http://www.digital-archiv.at/ns/glaser-tei/config" at "modules/config.xqm";

declare variable $app-name := doc(concat($config:app-root, "/repo.xml"))//repo:target/text();

let $hansi := "asd"
return $app-name