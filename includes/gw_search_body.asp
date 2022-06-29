<%
	' --------------------------------------------------------------------------
	' SEARCH-BODY.ASP
	' --------------------------------------------------------------------------
	' Author:	Dario Mratovich (dario.mratovich@nationalarchives.gov.uk)
	' Created:	23/06/2003
	' Purpose:	Searches Index Server catalogue for Learning Curve British
	'			Empire exhibition and displays search results
	' Notes:	Ensure that changes listed in search-header.asp have been made
	'				prior to going live.
	'			Ensure the path to "/empire" in the
	'				code that builds strDocURL - the link that is followed for
	'				this search result - is correct for this server.
	' --------------------------------------------------------------------------
	If IsArray(avarResults) Then
		intTotalResults   = UBound(avarResults, 2)
		
		' get total number of pages
		If (intTotalResults + 1) Mod intResultsPerPage <> 0 Then
			intTotalPages = Int((intTotalResults + 1) / intResultsPerPage) + 1
		Else
			intTotalPages = (intTotalResults + 1) / intResultsPerPage
		End If ' (intTotalResults + 1) Mod intResultsPerPage <> 0
		
		' check that current page is within allowed range
		If intCurPageNum < 1 Then
			intCurPageNum = 1
		ElseIf intCurPageNum > intTotalPages Then
			intCurPageNum = intTotalPages
		End If
		
		' build string for navigation between pages
		If intTotalPages > 1 Then
			' add page and previous/next links as appropriate
			strPageNavLinks = strPageNavLinks & "Show page(s): "
			
			' loop for each page
			For intPageNum = 1 To intTotalPages
				If intPageNum = intCurPageNum Then
					strPageNavLinks = strPageNavLinks & " <b>" & intCurPageNum & "</b>"
				Else
					' build URL for this page link
					strURL = strSearchScript & "?keys=" & Server.URLEncode(strSearchString) _
						& "&p=" & Server.URLEncode(intPageNum) _
						& "&action=search"
					
					strPageNavLinks = strPageNavLinks & " <a href=""" & strURL & """>" & intPageNum & "</a>"
				End If ' intPageNum = intCurPageNum
			Next ' intPageNum = 1 To intTotalPages
		End If ' intTotalPages > 1
		
		' separate page numbers from previous/next links
		strPageNavLinks = strPageNavLinks & "<br>"
		
		' add a previous link
		If intCurPageNum > 1 Then
			' build URL for this page link
			strURL = strSearchScript & "?keys=" & Server.URLEncode(strSearchString) _
				& "&p=" & Server.URLEncode(intCurPageNum - 1) _
				& "&action=search"
			
			strPageNavLinks = strPageNavLinks & "<a href=""" & strURL & """>&lt; Previous page</a>"
		End If ' intCurPage > 1
		
		' add a separator string if neccessary
		If intCurPageNum > 1 And intCurPageNum < intTotalPages Then
			strPageNavLinks = strPageNavLinks & " | "
		End If ' intCurPageNum > 1 And intCurPageNum < intTotalPages
		
		' add a next link
		If intCurPageNum < intTotalPages Then
			' build URL for this page link
			strURL = strSearchScript & "?keys=" & Server.URLEncode(strSearchString) _
				& "&p=" & Server.URLEncode(intCurPageNum + 1) _
				& "&action=search"
			
			strPageNavLinks = strPageNavLinks & "<a href=""" & strURL & """>Next page &gt;</a>"
		End If ' intCurPageNum < intTotalPages
		
		intStartResult = (intCurPageNum * intResultsPerPage) - intResultsPerPage + 1
		intEndResult   = intCurPageNum * intResultsPerPage
		If intEndResult > (intTotalResults + 1) Then
			intEndResult = intTotalResults + 1
		End If ' intEndResult > (intTotalResults + 1)
%>
        <table width="100%" border="0" cellspacing="0" cellpadding="4" align="center">
          <tr bgcolor="#FFFFFF">
            <td class="bodyblack" align="center" colspan="2">
              <p><strong>Search Results</strong>:
                Showing <% = intStartResult %> to <% = intEndResult %>  of <% = intTotalResults + 1 %> document(s) matching &quot;<% = Server.HTMLEncode(strSearchString) %>&quot; in British Empire</p>
            </td>
          </tr>
          <tr>
            <td class="searchnormal" align="center" colspan="2">&nbsp;</td>
          </tr>
<%
		For intResult = (intStartResult - 1) To (intEndResult - 1)
			' get document title (or filename if no title)
			If Len(avarResults(DOCTITLE, intResult)) > 0 Then
				strDocTitle = avarResults(DOCTITLE, intResult)
			Else
				strDocTitle = avarResults(FILENAME, intResult)
			End If
			
			' get document search description meta data (or default charazcterization if none)
			If Len(avarResults(SEARCH_DESCRIPTION, intResult)) > 0 Then
				strDocDescription = avarResults(SEARCH_DESCRIPTION, intResult)
			ElseIf Len(avarResults(CHARACTERIZATION, intResult)) > 0 Then
				strDocDescription = avarResults(CHARACTERIZATION, intResult)
			End If
			
			' strip out <noscript> tag content, and tail off descriptions with "..." after last space character
			objRegExp.Pattern = "^This website requires Javascript to be enabled\.\.(:? source \d+[a]?\.)?(.*)\s.*?$"
			objRegExp.IgnoreCase = True
			strDocDescription = objRegExp.Replace(strDocDescription, "$2...")
			
			' get document URL
			' check if this is a transcript or usefulnotes URL
			objRegExp.Pattern = "^.*?(?:/transcript/|/usefulnotes/)g\d+?cs\d+?s\d+?(?:u|t|ts).htm$"
			objRegExp.IgnoreCase = True
			
			If objRegExp.Test(avarResults(VPATH, intResult)) Then
				strDocURL = "http://" & Request.ServerVariables("SERVER_NAME") & "/empire" & avarResults(SEARCH_LINK_TO_SOURCE, intResult)
			Else
				strDocURL = "http://" & Request.ServerVariables("SERVER_NAME") & avarResults(VPATH, intResult)
			End If
			
			' strip off the "The National Archives Learning Curve | British Empire | " part of the page title
			strDocTitle = Replace(strDocTitle, "The National Archives Learning Curve | British Empire | ", "")
%>
          <tr>
            <td width="4%" valign="top" align="right" class="bodyblack"><strong><% = intResult + 1 %>.</strong></td>
            <td width="96%" valign="top" class="bodyblack">
              <strong><a href="<% = strDocURL %>"><% = strDocTitle %></a></strong><br>
              <% = strDocDescription %><br>
              URL: <% = strDocURL %>
            </td>
          </tr>
<%
		Next
%>
          <tr>
            <td colspan="2" class="bodyblack">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" align="center" class="bodyblack"><% = strPageNavLinks %></td>
          </tr>
        </table>
<%
	Else
		If strError <> "" Then
			Response.Write "<p class=""bodyblack"">" & strError & "</p>"
		End If ' strError <> ""
	End If ' Not(rstRecordSet.EOF Or rstRecordSet.EOF)
%>
