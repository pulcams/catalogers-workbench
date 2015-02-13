xquery version "3.0";

(:~
 : This module defines the RESTXQ functions and endpoints used when executing a search
 : against the WorldCat Search API. It accepts submissions from an XForms search interface
 : and queries the API to retrieve MARCXML records. 
 :
 : @see http://www.oclc.org/developer/develop/web-services/worldcat-search-api.en.html
 : @author tat2
 : @version 0.1
 :)
 
module namespace wb-search = "http://libserv6.princeton.edu/exist/apps/workbench/search";

import module namespace functx="http://www.functx.com";

declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace httpclient = "http://exist-db.org/xquery/httpclient";
declare namespace http = "http://expath.org/ns/http-client";
declare namespace oclc-sru = "http://www.loc.gov/zing/srw/";
declare namespace wb = "http://libserv6.princeton.edu/exist/apps/workbench";

declare variable $wb-search:oclc-uri := "http://www.worldcat.org/webservices/catalog/search/sru?query=";
declare variable $wb-search:oclc-defaults := "&amp;sortKeys=relevance&amp;servicelevel=full";
declare variable $wb-search:oclc-key := "&amp;wskey=YOUR KEY HERE";

(:~
: Accepts an XML document submitted from the XForms interface and uses it to query the WorldCat Search API.
: Possible fields to query are title, personal name, corporate/conference name, ISBN, ISSN, or standard number (e.g., EAN).
: Title and name can be searched in combination with each other. 
:
: @param $query An XML document POSTed from XForms submission
: @return Either MARCXML, a notification that there were no results, or an appropriate error message (server or client) 
:) 

declare    
    %rest:path("/query")
    %rest:POST("{$query}")
    %rest:consumes("application/xml")
    %rest:produces("application/xml")
function wb-search:oclc-search($query as document-node()) as element()* {
    
    let $uri := $wb-search:oclc-uri,
        $defaults := $wb-search:oclc-defaults,
        $key := $wb-search:oclc-key            
    
    (: Assign POSTed values to variables. :)
    let $title := $query//wb:title[normalize-space()], 
        $persname := $query//wb:persName[normalize-space()],
        $corpname := $query//wb:corpName[normalize-space()], 
        $isbn := $query//wb:isbn[normalize-space()],
        $issn := $query//wb:issn[normalize-space()], 
        $sn := $query//wb:sn[normalize-space()]        
        
    let $string-searches := if ($title castable as xs:string and $persname castable as xs:string)
                            then concat("srw.ti all &quot;", $title, "&quot;", " and ", "srw.pn all &quot;", $persname, "&quot;") 
                            else if ($title castable as xs:string and $corpname castable as xs:string)
                                 then concat("srw.ti all &quot;", $title, "&quot;", " and ", "srw.cn all &quot;", $corpname, "&quot;")
                            else if ($title castable as xs:string and not($persname castable as xs:string or $corpname castable as xs:string))
                                 then concat("srw.ti all &quot;", $title, "&quot;")
                            else if ($persname castable as xs:string and not($title castable as xs:string))
                                 then concat("srw.pn all &quot;", $persname, "&quot;")
                            else if ($corpname castable as xs:string and not($title castable as xs:string))
                                 then concat("srw.cn all &quot;", $corpname, "&quot;")
                            else ()                               
    
    let $num-searches := if ($isbn castable as xs:integer)
                         then concat("srw.bn = &quot;", $isbn, "&quot;")
                         else if ($issn castable as xs:string)
                              then concat("srw.in = &quot;", $issn, "&quot;")
                         else if ($sn castable as xs:integer)
                              then concat("srw.sn = &quot;", $sn, "&quot;")
                         else ()                         
        
    (: Encode search strings for URI and concat with SRU syntax. :)   
    let $search-uri := if ($string-searches[normalize-space()] castable as xs:string)
                       then concat($uri, encode-for-uri($string-searches), $defaults, $key)
                       else if ($num-searches[normalize-space()] castable as xs:string)
                            then concat($uri, encode-for-uri($num-searches), $defaults, $key)
                       else ()        
    
    (: Execute search. :)
    let $request := <http:request href="{$search-uri}" method="GET"/>
    let $response := http:send-request($request)
    let $head := $response[1]
    
    return
        if ($head/@status = "200") then
            <results>{      
                if ($response//oclc-sru:record)
                then for $r in $response     
                     (: Add @wb-search:test for adding a checkbox to the XForms interface. :)
                     return $r//oclc-sru:record/functx:add-attributes(., xs:QName("wb-search:test"), "false")
                else <message>Sorry, there were no results for your search.</message>       
            }</results>
        else
            <error><message>Oops, something went wrong!</message>{ $head }</error>
            
};


