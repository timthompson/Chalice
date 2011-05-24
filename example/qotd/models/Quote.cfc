/**
 * @persistent true
 */
 
component {
	/**
	 * @fieldtype id
	 * @generator identity
	 */
	property id;
	property content;
	property author;
	property created;
	
	function init( author = "", content = "" ){
		variables.author  = arguments.author;
		variables.content = arguments.content;
		variables.created = Now( );
		
		return this;
	}
	
	function save( ){
		EntitySave( this );
		
		return this;
	}
}