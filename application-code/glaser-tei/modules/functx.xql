xquery version "3.0";

module namespace functx="http://www.functx.com";

(:~
 : The functx:is-value-in-sequence function returns a boolean value indicating whether or not an atomic value is equal (based on typed values) to a value in the sequence. If $value or $seq is the empty sequence, it returns false.
:)
declare function functx:is-value-in-sequence
  ( $value as xs:anyAtomicType? ,
    $seq as xs:anyAtomicType* )  as xs:boolean {
   $value = $seq
 } ;
 

declare function functx:substring-after-last
  ( $arg as xs:string? ,
    $delim as xs:string )  as xs:string {
    replace ($arg,concat('^.*',$delim),'')
 };

declare function functx:substring-after-if-contains
  ( $arg as xs:string? ,
    $delim as xs:string )  as xs:string? {

   if (contains($arg,$delim))
   then substring-after($arg,$delim)
   else $arg
 } ;

declare function functx:is-value-in-sequence
  ( $value as xs:anyAtomicType? ,
    $seq as xs:anyAtomicType* )  as xs:boolean {

   $value = $seq
 } ;

declare function functx:name-test
  ( $testname as xs:string? ,
    $names as xs:string* )  as xs:boolean {

$testname = $names
or
$names = '*'
or
functx:substring-after-if-contains($testname,':') =
   (for $name in $names
   return substring-after($name,'*:'))
or
substring-before($testname,':') =
   (for $name in $names[contains(.,':*')]
   return substring-before($name,':*'))
 } ;


declare function functx:remove-elements-deep
  ( $nodes as node()* ,
    $names as xs:string* )  as node()* {

   for $node in $nodes
   return
     if ($node instance of element())
     then if (functx:name-test(name($node),$names))
          then ()
          else element { node-name($node)}
                { $node/@*,
                  functx:remove-elements-deep($node/node(), $names)}
     else if ($node instance of document-node())
     then functx:remove-elements-deep($node/node(), $names)
     else $node
 } ;
 
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