<!DOCTYPE html>
<html>
<head>
<title>Random Quote</title>
</head>

<body>
	<cfoutput>
	<div id="quote">
		<q>#request.quote.getContent( )#</q>
		<p>#request.quote.getAuthor( )#</p>
	</div>
	</cfoutput>
</body>
</html>
