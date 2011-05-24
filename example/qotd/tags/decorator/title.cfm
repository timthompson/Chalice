<cfsetting enablecfoutputonly="true" />

<!--- Pass in a default title to use if the decorated page doesn't have a title --->
<cfparam 
	name    = "attributes.default"
	default = "" 
/>

<!--- Pass in the page to decorate - this will usually be page="#target#" --->
<cfparam
	name    = "attributes.page"
	default = ""
/>

<cfif thisTag.ExecutionMode is "start">
	<cffile action="read" variable="content" file="#ExpandPath( attributes.page )#" />
	<cfset title = ReMatch( "<title>(.*?)</title>", content ) />
	<cfset xmlDoc = XmlParse( title[ 1 ] ) />
	<cfif xmlDoc.title neq "">
		<cfoutput>#xmlDoc.title.xmlText#</cfoutput>
	<cfelse>
		<cfoutput>#attributes.default#</cfoutput>
	</cfif>
</cfif>
<cfsetting enablecfoutputonly="false" />