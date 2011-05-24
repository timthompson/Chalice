<!---
	Usage :
	Display current date as MM/DD/YYYY
	<date />
	Format current date
	<date format="MMM DD, YYYY" />
	Display any date
	<date date="June 5, 2002" />
	Add 2 years to date
	<date addYears="2" />
--->
<cfparam 
	name    = "attributes.date" 
	default = "#Now( )#" 
/>

<cfparam 
	name    = "attributes.addYears" 
	default = "0" 
/>

<cfparam 
	name    = "attributes.addMonths" 
	default = "0" 
/>

<cfparam 
	name    = "attributes.addDays" 
	default = "0" 
/>

<cfparam 
	name    = "attributes.format" 
	default = "MM/DD/YYYY" 
/>

<cfset attributes.date = DateAdd( "yyyy", attributes.addYears, attributes.date ) />
<cfset attributes.date = DateAdd( "m", attributes.addMonths, attributes.date ) />
<cfset attributes.date = DateAdd( "d", attributes.addDays, attributes.date ) />

<cfif thisTag.ExecutionMode is "start">
	<cfoutput>#DateFormat( attributes.date, attributes.format )#</cfoutput>
<cfelse>

</cfif>