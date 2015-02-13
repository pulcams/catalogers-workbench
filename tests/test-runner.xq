xquery version "3.0";
 
(: This main module fires off the tests stored in tests.xql :)
 
import module namespace test = "http://exist-db.org/xquery/xqsuite" at "resource:org/exist/xquery/lib/xqsuite/xqsuite.xql";
import module namespace inspect = "http://exist-db.org/xquery/inspection";
import module namespace wb-test-search = "http://libserv6.princeton.edu/exist/apps/workbench/test/search" at "test-search.xqm";

let $test-search-modules := (
    xs:anyURI("/db/apps/workbench/tests/test-search.xqm")
)
let $test-search-functions := $test-search-modules ! inspect:module-functions(.)
return
test:suite($test-search-functions) 