<cfsetting enablecfoutputonly = "true" />
<cfparam
	name    = "attributes.page"
	default = ""
/>

<cfif thisTag.ExecutionMode is "start">
	<cffile action="read" variable="content" file="#ExpandPath( attributes.page )#" />
	<cfset content = ReReplace( content, "<body\b[^>]*>", "<body><![CDATA[<cfoutput>" ) />
	<cfset content = Replace( content, "</body>", "</cfoutput>]]></body>" ) />
	<cfset xmlDoc = XmlParse( content ) />
	<cfoutput>#xmlDoc.html.body.xmlText#</cfoutput>
</cfif>
<cfsetting enablecfoutputonly = "false" />