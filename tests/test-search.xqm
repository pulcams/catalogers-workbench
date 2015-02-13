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
        <wb:persName></wb:persName>
        <wb:corpName></wb:corpName>
        <wb:title>Land of Shant</wb:title>
        <wb:isbn></wb:isbn>
        <wb:issn></wb:issn>
        <wb:sn></wb:sn>                
    </wb:query>),
    xmldb:store("/db/apps/workbench/tests/test-records", "search-test-2.xml", 
    <wb:query>
        <wb:persName>Pérez, Henok</wb:persName>
        <wb:corpName></wb:corpName>
        <wb:title></wb:title>
        <wb:isbn></wb:isbn>
        <wb:issn></wb:issn>
        <wb:sn></wb:sn>                
    </wb:query>),    
    xmldb:store("/db/apps/workbench/tests/test-records", "search-test-3.xml", 
    <wb:query>
        <wb:persName></wb:persName>
        <wb:corpName>Província Camiliana Brasileira</wb:corpName>
        <wb:title></wb:title>
        <wb:isbn></wb:isbn>
        <wb:issn></wb:issn>
        <wb:sn></wb:sn>                
    </wb:query>),
    xmldb:store("/db/apps/workbench/tests/test-records", "search-test-4.xml", 
    <wb:query>
        <wb:persName>Pérez, Henok</wb:persName>
        <wb:corpName></wb:corpName>
        <wb:title>Land of Shant</wb:title>
        <wb:isbn></wb:isbn>
        <wb:issn></wb:issn>
        <wb:sn></wb:sn>                
    </wb:query>),
    xmldb:store("/db/apps/workbench/tests/test-records", "search-test-5.xml", 
    <wb:query>
        <wb:persName></wb:persName>
        <wb:corpName></wb:corpName>
        <wb:title></wb:title>
        <wb:isbn>9786124165139</wb:isbn>
        <wb:issn></wb:issn>
        <wb:sn></wb:sn>                
    </wb:query>),
    xmldb:store("/db/apps/workbench/tests/test-records", "search-test-6.xml", 
    <wb:query>
        <wb:persName></wb:persName>
        <wb:corpName></wb:corpName>
        <wb:title></wb:title>
        <wb:isbn></wb:isbn>
        <wb:issn>1996-8663</wb:issn>
        <wb:sn></wb:sn>                
    </wb:query>),
    xmldb:store("/db/apps/workbench/tests/test-records", "search-test-7.xml", 
    <wb:query>
        <wb:persName></wb:persName>
        <wb:corpName></wb:corpName>
        <wb:title></wb:title>
        <wb:isbn></wb:isbn>
        <wb:issn></wb:issn>
        <wb:sn>7898114691107</wb:sn>                
    </wb:query>),
    xmldb:store("/db/apps/workbench/tests/test-records", "search-test-8.xml", 
    <wb:query>
        <wb:persName>Pérez, Henok</wb:persName>
        <wb:corpName></wb:corpName>
        <wb:title></wb:title>
        <wb:isbn></wb:isbn>
        <wb:issn></wb:issn>
        <wb:sn>7898114691107</wb:sn>                
    </wb:query>),
    xmldb:store("/db/apps/workbench/tests/test-records", "search-test-9.xml", 
    <wb:query>
        <wb:persName>Pérez, Henok</wb:persName>
        <wb:corpName>Província Camiliana Brasileira</wb:corpName>
        <wb:title>adfadfadsf</wb:title>
        <wb:isbn>9786124165139</wb:isbn>
        <wb:issn>1996-8663</wb:issn>
        <wb:sn>7898114691107</wb:sn>                
    </wb:query>)
};

(: Remove test data. :)

declare
%test:tearDown
function wb-test-search:_test-teardown() {
    xmldb:remove("/db/apps/workbench/tests/test-records")
};

(:
 : Given an XML document with elements containing search strings,
 : run a search against the World Search API (using SRU query params).
 :)
 
(:~
 : Scenario: Querying WorldCat Search API successfully with title search
 : Story:    #Search_WorldCat 
 : Behavior: When a user submits a successful title search to the WorldCat Search API
 :           Then one or more MARCXML records should returned  
 : Test:     Passes if there is a value for the <wb:title> element 
 :           and a child <record> element is returned.
 :)

declare
%test:args("/db/apps/workbench/tests/test-records/search-test-1.xml")
%test:assertXPath("count($result/*[local-name() = 'record']) >= 1")
function wb-test-search:oclc-test-for-results-by-title($query-path as xs:string) {
    let $arg := doc($query-path)
    return        
        wb-search:oclc-search($arg)        
}; 

(:~
 : Scenario: Querying WorldCat Search API successfully with personal name search
 : Story:    #Search_WorldCat 
 : Behavior: When a user submits a successful personal name search to the WorldCat Search API
 :           Then one or more MARCXML records should returned  
 : Test:     Passes if there is a value for the <wb:persName> element 
 :           and a child <record> element is returned.
 :)

declare
%test:args("/db/apps/workbench/tests/test-records/search-test-2.xml")
%test:assertXPath("count($result/*[local-name() = 'record']) >= 1")
function wb-test-search:oclc-test-for-results-by-persName($query-path as xs:string) {
    let $arg := doc($query-path)
    return        
        wb-search:oclc-search($arg)        
}; 

(:~
 : Scenario: Querying WorldCat Search API successfully with corporate name search
 : Story:    #Search_WorldCat 
 : Behavior: When a user submits a successful corporate name search to the WorldCat Search API
 :           Then one or more MARCXML records should returned  
 : Test:     Passes if there is a value for the <wb:corpName> element 
 :           and a child <record> element is returned.
 :)

declare
%test:args("/db/apps/workbench/tests/test-records/search-test-3.xml")
%test:assertXPath("count($result/*[local-name() = 'record']) >= 1")
function wb-test-search:oclc-test-for-results-by-corpName($query-path as xs:string) {
    let $arg := doc($query-path)
    return       
        wb-search:oclc-search($arg)        
}; 

(:~
 : Scenario: Querying WorldCat Search API successfully with personal name and title search
 : Story:    #Search_WorldCat 
 : Behavior: When a user submits a successful personal name and title search to the WorldCat Search API
 :           Then one or more MARCXML records should returned  
 : Test:     Passes if there is a value for the <wb:title> and <wb:persName> elements 
 :           and a child <record> element is returned.
 :)

declare
%test:args("/db/apps/workbench/tests/test-records/search-test-4.xml")
%test:assertXPath("count($result/*[local-name() = 'record']) >= 1")
function wb-test-search:oclc-test-for-results-by-title-and-persName($query-path as xs:string) {
    let $arg := doc($query-path)
    return        
        wb-search:oclc-search($arg)        
};

(:~
 : Scenario: Querying WorldCat Search API successfully with ISBN search
 : Story:    #Search_WorldCat 
 : Behavior: When a user submits a successful corporate name search to the WorldCat Search API
 :           Then one or more MARCXML records should returned  
 : Test:     Passes if there is an integer value for the <wb:isbn> element 
 :           and a child <record> element is returned.
 :)

declare
%test:args("/db/apps/workbench/tests/test-records/search-test-5.xml")
%test:assertXPath("count($result/*[local-name() = 'record']) >= 1")
function wb-test-search:oclc-test-for-results-by-isbn($query-path as xs:string) {
    let $arg := doc($query-path)
    return        
        wb-search:oclc-search($arg)        
};

(:~
 : Scenario: Querying WorldCat Search API successfully with ISSN search
 : Story:    #Search_WorldCat 
 : Behavior: When a user submits a successful corporate name search to the WorldCat Search API
 :           Then one or more MARCXML records should returned  
 : Test:     Passes if there is an string value for the <wb:issn> element 
 :           and a child <record> element is returned.
 :)

declare
%test:args("/db/apps/workbench/tests/test-records/search-test-6.xml")
%test:assertXPath("count($result/*[local-name() = 'record']) >= 1")
function wb-test-search:oclc-test-for-results-by-issn($query-path as xs:string) {
    let $arg := doc($query-path)
    return        
        wb-search:oclc-search($arg)        
};

(:~
 : Scenario: Querying WorldCat Search API successfully with standard number search
 : Story:    #Search_WorldCat 
 : Behavior: When a user submits a successful corporate name search to the WorldCat Search API
 :           Then one or more MARCXML records should returned  
 : Test:     Passes if there is an integer value for the <wb:sn> element 
 :           and a child <record> element is returned.
 :)

declare
%test:args("/db/apps/workbench/tests/test-records/search-test-7.xml")
%test:assertXPath("count($result/*[local-name() = 'record']) >= 1")
function wb-test-search:oclc-test-for-results-by-sn($query-path as xs:string) {
    let $arg := doc($query-path)
    return        
        wb-search:oclc-search($arg)        
};

(:~
 : Scenario: Querying WorldCat Search API with a server error
 : Story:    #Search_WorldCat 
 : Behavior: When a user submits a search to the WorldCat Search API
 :           and the response code is something other than 200
 :           Then an error should be raised in an <error> element and
 :           the contents of the HTTP header should be displayed
 : Test:     Passes if there is no child <error> element.
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
 : Scenario: Querying WorldCat Search API with a server error
 : Story:    #Search_WorldCat 
 : Behavior: If a user attempts to submit a search to the WorldCat Search API
 :           with both a string field (e.g., <wb:title>) and a numeric field (e.g., <wb:isbn>)
 :           Then the search should not be submitted
 : Test:     Handle through XForms validation
 :)
 
(:~
 : Scenario: Querying WorldCat Search API with no result
 : Story:    #Search_WorldCat 
 : Behavior: When a user submits a search to the WorldCat Search API,
 :           and there search does not return one or more MARXCXML
 :           records
 :           Then a message should be returned notifying the user
 :           that there were no results
 : Test:     Passes if there is a child <message> element.
 :)
 
declare
%test:args("/db/apps/workbench/tests/test-records/search-test-9.xml")
%test:assertXPath("exists($result/message)")
function wb-test-search:oclc-test-for-no-results($query-path as xs:string) {
    let $arg := doc($query-path)    
    return                
        wb-search:oclc-search($arg)
};
 
(:~
 : Scenario: Querying WorldCat Search API with no result
 : Story:    #Search_WorldCat 
 : Behavior: When a user submits a search to the WorldCat Search API,
 :           and there search does not return one or more MARXCXML
 :           records
 :           Then a message should be returned notifying the user
 :           that there were no results. 
 : Test:     Passes if there is a child <message> element.
 :)
 
 
 
 
 
 


