<cfsetting enablecfoutputonly = "true" />
<cfparam
	name    = "attributes.page"
	default = ""
/>

<cfif thisTag.ExecutionMode is "start">
	<cffile action = "read" variable="content" file="#ExpandPath( attributes.page )#" />
	<cfset content = Replace( content, "<head>", "<head><![CDATA[<cfoutput>" ) />
	<cfset content = Replace( content, "</head>", "</cfoutput>]]></head>" ) />
	<cfset content = ReReplace( content, "<title>(.*?)</title>", "" ) />
	<cfset head    = ReMatch( "<head>(.*?)</head>", content ) />
	<cfset xmlDoc  = XmlParse( head[1] ) />
	<cfoutput>#xmlDoc.head.xmlText#</cfoutput>
</cfif>
<cfsetting enablecfoutputonly = "false" />