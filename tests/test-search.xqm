xquery version "3.0";

(:~
 : This library module contains XQSuite tests for the wb-search module stored in modules/search.xqm.
 : 
 : @author tat2
 : @version 0.1
 :)
 
module namespace wb-test-search = "http://libserv6.princeton.edu/exist/apps/workbench/test/search";
 
import module namespace wb-search = "http://libserv6.princeton.edu/exist/apps/workbench/search" at "../modules/search.xqm";
 
declare namespace test = "http://exist-db.org/xquery/xqsuite"; 
declare namespace wb = "http://libserv6.princeton.edu/exist/apps/workbench";

(: Set up test data. :)

declare
%test:setUp
function wb-test-search:_test-setup() {
    xmldb:create-collection("/db/apps/workbench/tests", "test-records"),
    xmldb:store("/db/apps/workbench/tests/test-records", "search-test-1.xml", 
    <wb:query>
        <wb:persName>Pérez, Henock</wb:persName>
        <wb:corpName>Província Camiliana Brasileira</wb:corpName>
        <wb:title>Land of Shant</wb:title>
        <wb:isbn>9786124165139</wb:isbn>
        <wb:issn>19968663</wb:issn>
        <wb:sn>7898114691107</wb:sn>                
    </wb:query>),
    xmldb:store("/db/apps/workbench/tests/test-records", "search-test-2.xml", 
    <wb:query>
        <wb:persName>Pérez, Henock</wb:persName>
        <wb:corpName>Província Camiliana Brasileira</wb:corpName>
        <wb:title>adfadfadsf</wb:title>
        <wb:isbn>9786124165139</wb:isbn>
        <wb:issn>19968663</wb:issn>
        <wb:sn>7898114691107</wb:sn>                
    </wb:query>)
};

(: Remove test data. :)

declare
%test:tearDown
function wb-test-search:_test-teardown() {
    xmldb:remove("/db/apps/workbench/tests/test-records")
};

(:~
 : Given an XML document with elements containing search strings,
 : run a search against the World Search API (using SRU query params).
 : Test to see whether one or more MARCXML records has been returned.
 :::: If a MARCXML record has been returned,  
 :::: the result should have a child <record> element.
 :)

declare
%test:args("/db/apps/workbench/tests/test-records/search-test-1.xml")
%test:assertXPath("count($result/*[local-name() = 'record']) >= 1")
function wb-test-search:oclc-test-for-results($query-path as xs:string) {
    let $arg := doc($query-path)
    return
        wb-search:oclc-search($arg)
}; 

(:~
 : Given an XML document with elements containing search strings,
 : run a search against the World Search API (using SRU query params).
 : Test for a server response code of 200.
 :::: If the server response code is not 200,  
 :::: an <error> element with an error message should be produced.
 :)

declare
%test:args("/db/apps/workbench/tests/test-records/search-test-1.xml")
%test:assertXPath("not($result/error)")
function wb-test-search:oclc-test-for-server($query-path as xs:string) {
    let $arg := doc($query-path)
    return
        wb-search:oclc-search($arg)
};
 
(:~
 : Given an XML document with elements containing search strings,
 : run a search against the World Search API (using SRU query params).
 : Test for a search with no results.
 :::: If no MARCXML records are returned,
 :::: a <message> element should be returned, notifying the user that there were no results. 
 :)
 
declare
%test:args("/db/apps/workbench/tests/test-records/search-test-2.xml")
%test:assertXPath("exists($result/message)")
function wb-test-search:oclc-test-for-no-results($query-path as xs:string) {
    let $arg := doc($query-path)    
    return                
        wb-search:oclc-search($arg)
};
 
 
 
 
 
 
 
 


