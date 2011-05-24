/**
 * @defaultAction home
 */
 
component {
	function home( ){
		WriteOutput("<h1>Real Programmers do not eat Quiche</h1>");
	}
	
	function initQuotes( ){
		
		new models.Quote( 
			author  = "Larry Wall", 
			content = "There is more than one method to our madness." 
		).save( );
		
		new models.Quote( 
			author  = "Chuck Norris Facts", 
			content = "Chuck Norris always uses his own design patterns, and his favorite is the Roundhouse Kick" 
		).save( );
		
		new models.Quote( 
			author  = "Eric Raymond", 
			content = "Being a social outcast helps you stay concentrated on the really important things, like thinking and hacking." 
		).save( );
	}
	
	/**
	 * @layout random
	 */
	 
	function random( ){
		var allQuotes = EntityLoad( "Quote" );
		var randomQuote = "";

		if ( allQuotes.size( ) > 0 ){
			var randomIdx = RandRange( 1, allQuotes.size( ) );
			randomQuote = allQuotes[ randomIdx ];
		} else {
			randomQuote = new models.Quote( author  = "Anonymous", content = "Real Programmers don't eat much quiche" ).save( );
		}
		return {
			quote = randomQuote
		};
	}
}