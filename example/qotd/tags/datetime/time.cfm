<cfparam 
	name    = "attributes.time" 
	default = "#Now( )#" 
/>

<cfparam 
	name    = "attributes.addHours" 
	default = "0" 
/>

<cfparam 
	name    = "attributes.addMinutes" 
	default = "0" 
/>

<cfparam 
	name    = "attributes.addSeconds" 
	default = "0" 
/>

<cfparam 
	name    = "attributes.format" 
	default = "h:mm:ss tt" 
/>

<cfset attributes.time = DateAdd( "h", attributes.addHours, attributes.time ) />
<cfset attributes.time = DateAdd( "n", attributes.addMinutes, attributes.time ) />
<cfset attributes.time = DateAdd( "s", attributes.addSeconds, attributes.time ) />

<cfif thisTag.ExecutionMode is "start">
	<cfoutput>#TimeFormat( attributes.time, attributes.format )#</cfoutput>
<cfelse>

</cfif>