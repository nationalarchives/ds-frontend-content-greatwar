<%
	' --------------------------------------------------------------------------
	' SEARCH-HEADER.ASP
	' --------------------------------------------------------------------------
	' Author:	Dario Mratovich (dario.mratovich@nationalarchives.gov.uk)
	' Created:	23/06/2003
	' Purpose:	Searches Index Server catalogue for Learning Curve British
	'			Empire exhibition and displays search results
	'           --------------------------------------
	' Notes:	WHEN MOVING FROM ONE SERVER TO ANOTHER
	'           --------------------------------------
	'           Ensure the catalogue name ("objQuery.Catalog" in this page) matches
	'               the Indexing Service catalogue name that is indexing the Learning Curve site on this
	'               server.
	'			Ensure the paths to the /empire content folders 
	'               ("objUtil.AddScopeToQuery" in this page) are pointing to the correct folders on this
	'               server.
	'			Ensure that Indexing Service re-indexes and
	'				creates custom properties "searchdescription" and
	'				"searchlinktosource" as included in META elements on some
	'				pages
	'           Ensure that in Indexing Service, the custom property "searchlinktosource" is 
	'               cached so that it can be output into the page 
	'               (Datatype: VT_LPWSTR, Size: 4, Storage Level: Secondary).
	'           Ensure that the changes listed in search-body.asp have also been made.
	' --------------------------------------------------------------------------
	
	Option Explicit
	
	Dim objQuery
	Dim objUtil
	Dim objRegExp
	Dim rstRecordSet
	Dim avarResults
	Dim intResult
	Dim intStartResult
	Dim intEndResult
	Dim intTotalResults
	Dim intResultsPerPage
	Dim intPageNum
	Dim intCurPageNum
	Dim intTotalPages
	
	Dim blnSearchSubmitted  ' flag to check if search form was submitted
	
	Dim strCustomColumn
	
	Dim strSearchScript
	Dim strSearchString
	Dim strPageNum
	Dim strURL
	Dim strPageNavLinks
	
	Dim strDocTitle
	Dim strDocDescription
	Dim strDocURL
	Dim strGalleryNum
	Dim strCaseStudyNum
	Dim strSourceNum
	
	Dim strError
	
	' constants for .GetRows results array
	Const VPATH                 = 0
	Const DOCTITLE              = 1
	Const HITCOUNT              = 2
	Const FILENAME              = 3
	Const SEARCH_DESCRIPTION    = 4
	Const CHARACTERIZATION      = 5
	Const SEARCH_LINK_TO_SOURCE = 6
	
	
	' set number of results per page
	intResultsPerPage = 10
	
	' get the script name
	strSearchScript = Request.ServerVariables("SCRIPT_NAME") 
	
	' get parameters passed
	strSearchString = Trim(Request("keys"))
	strPageNum      = Trim(Request("p"))
		
	' create regular expression object
	Set objRegExp = New RegExp
	
	' match a number
	objRegExp.Pattern = "^\d+$"
	
	' default page to 1 if not a number
	If Not objRegExp.Test(strPageNum) Then
		intCurPageNum = 1
	Else
		intCurPageNum = CInt(strPageNum)
	End If ' Not objRegExp.Test(strPageNum)
	
	' match alphanumeric, quotes, wildcards and separator characters
	objRegExp.Pattern = "^[A-Za-z0-9_ \.,;:'""\*\?\-]+$"
	
	
	' check if the form was submitted (either from the search results page itself
	' (POST or GET if form submitted or page nav link clicked)
	' or from the search box on the site's pages (GET, <input type="image" name="Go"...>)
	If Request("action") = "search" _
	Or (Len(Request.QueryString("Go.x")) > 0 And Len(Request.QueryString("Go.y")) > 0) Then
		blnSearchSubmitted = True
	Else
		blnSearchSubmitted = False
	End If
	
	
	' check that the form was submitted
	If blnSearchSubmitted Then
		If strSearchString = "" Then
			strError = "Please enter a word or phrase to search for"
		ElseIf Not objRegExp.Test(strSearchString) Then
			strError = "The search text specified is invalid"
		Else
			' create a new query object
			Set objQuery = Server.CreateObject("IXSSO.Query")
			
			' define a custom column for the SearchDescription META property
			strCustomColumn = "SearchDescription = d1b5d3f0-c0b3-11cf-9a92-00a0c908dbf1 searchdescription"
			' add custom column to query object
			objQuery.DefineColumn(strCustomColumn)
			
			' define a custom column for the SearchLinkToSource META property
			strCustomColumn = "SearchLinkToSource = d1b5d3f0-c0b3-11cf-9a92-00a0c908dbf1 searchlinktosource"
			' add custom column to query object
			objQuery.DefineColumn(strCustomColumn)
			
			' build search query object
			objQuery.Catalog    = "learningcurve"
			objQuery.Query      = "(" & strSearchString & ") and not #filename g?cs?s?_bg*.htm and not #filename *.asp and not #filename *.xml"
			objQuery.Columns    = "vpath, DocTitle, HitCount, filename, searchdescription, characterization, searchlinktosource"
			objQuery.SortBy     = "rank[d]"
			objQuery.MaxRecords = 300
			
			' create a utility object to limit the searching scope
			Set objUtil = Server.CreateObject("IXSSO.Util")
			
			' limit the scope to the /empire folder
			objUtil.AddScopeToQuery objQuery, "/empire/", "shallow"
			objUtil.AddScopeToQuery objQuery, "/empire/credits/", "shallow"
			objUtil.AddScopeToQuery objQuery, "/empire/sitemap/", "shallow"
			objUtil.AddScopeToQuery objQuery, "/empire/transcript/", "shallow"
			objUtil.AddScopeToQuery objQuery, "/empire/usefulnotes/", "shallow"
			objUtil.AddScopeToQuery objQuery, "/empire/g1/", "deep"
			objUtil.AddScopeToQuery objQuery, "/empire/g2/", "shallow"
			objUtil.AddScopeToQuery objQuery, "/empire/g2/cs1/", "shallow"
			objUtil.AddScopeToQuery objQuery, "/empire/g2/cs2/", "shallow"
			objUtil.AddScopeToQuery objQuery, "/empire/g2/cs3/", "shallow"
			objUtil.AddScopeToQuery objQuery, "/empire/g2/cs4/", "shallow"
			objUtil.AddScopeToQuery objQuery, "/empire/g2/cs5/", "shallow"
			objUtil.AddScopeToQuery objQuery, "/empire/g2/cs6/", "shallow"
			objUtil.AddScopeToQuery objQuery, "/empire/g2/quiz/", "shallow"
			objUtil.AddScopeToQuery objQuery, "/empire/g2/worksheet/", "shallow"
			objUtil.AddScopeToQuery objQuery, "/empire/g3/", "deep"
			
			Set rstRecordSet = objQuery.CreateRecordSet("nonsequential")
			
			If Not(rstRecordSet.EOF Or rstRecordSet.EOF) Then
				avarResults = rstRecordSet.GetRows()
			Else
				strError = "No results were found that match your search"
			End If ' Not(rstRecordSet.EOF Or rstRecordSet.EOF)
			
			' cleanup
			Set objQuery = Nothing
			rstRecordSet.Close
			Set rstRecordSet = Nothing
		End If ' strSearchString = ""
	End If ' blnSearchSubmitted
%>
