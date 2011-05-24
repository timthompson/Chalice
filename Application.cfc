<cfcomponent output="false">
	<cfscript>
		this.sessionManagement = true;
		
		this.mappings[ "/" ] = ExpandPath( "." );
		this.mappings[ "/ram" ] = "ram://";

		/* 
		*	If action is omitted in the url, the default action is set to index 
		*   Override this by adding a defaultAction attribute to the controller.
		*/
		
		// url follows the form of http://localhost/index.cfm/controller/action
		// assuming Chalice is hosted in webroot
		this.dynamicRouting = [                                              // Matches (after index.cfm)
			{ "^/([\w]+)$"              = { controller = 1 } },               // /foo
			{ "^/([\w]+)/([\w]+)$"      = { controller = 1, action = 2 } }    // /foo/bar
		];
			
	</cfscript>

	<cfscript>
		/**
		 *@output false
		 */
		 
		boolean function onRequestStart( string targetPage ){
			var _route = StructNew( );
					
			// Look through the dynamicRouting and see if the url matches any of the regular expressions
			for( var i = ArrayLen( this.dynamicRouting ); i gte 1; i-- ){
				var match = REMatchNoCase( StructKeyArray( this.dynamicRouting[ i ] )[1], cgi.PATH_INFO );
				// if a match is found, loop through the regex groups and set the values listed in the dynamicRouting in the params variable
				if ( ArrayLen( match ) ){
					_route = REFindNoCase( StructKeyArray( this.dynamicRouting[ i ] )[1], match[ 1 ], 1, true );
					structAppend( variables, this.dynamicRouting[ i ][ StructKeyList( this.dynamicRouting[ i ] ) ]);
					for ( var x = 2; x lte ArrayLen( _route.pos ); x++ ){
						var _value = StructFindValue( this.dynamicRouting[ i ], x - 1 );
	
						switch ( _value[ 1 ].key ){
							case "action" :
								variables.action = mid( cgi.PATH_INFO, _route.pos[ x ], _route.len[ x ] );
							break;
							case "controller" :
								variables.controller = mid( cgi.PATH_INFO, _route.pos[ x ], _route.len[ x ] );
							break;
							default :
								request[ _value[ 1 ].key ] = mid( cgi.PATH_INFO, _route.pos[ x ], _route.len[ x ] );
							break;
						};
					};
					
					break;
				};
			};
									
			return true;
		};
	</cfscript>
	
	<cffunction name="onRequest" returntype="void" output="true">
		<cfargument name="targetPage" required="yes" type="string" />

		<!--- If no action is defined in the url, use the default action defined in controller.cfc or overriden --->
		<!--- in the target controller                                                                          --->
	
		<cfif Not StructKeyExists( variables, "action" )>
			<cfset variables.action = GetDefaultAction( controller = variables.controller ) />
		</cfif>
		
		<!--- Call the appropriate action within the controller cfc --->
		<cfinvoke 
			component          = "controllers/#variables.controller#" 
			method             = "#variables.action#"
			argumentcollection = "#request#"
			returnvariable     = "result"
		/>
		
		<!--- If the action returned a value, place it in the request scope so the view can access it --->
		<cfif StructKeyExists( variables, "result" )>
			<cfset StructAppend( request, variables.result ) />
		</cfif>

		<cfset view = "/views/#variables.controller#/#variables.action#.cfm" />
		
		<!--- If there is a view tied to the action, process it along with any decorator objects --->
		<cfif FileExists( ExpandPath( view ) )>
			<cffile action="read" variable="content" file="#ExpandPath( view )#" />
						
			<cfset decorator = GetLayout( controller = variables.controller, action = variables.action ) />
			<cfif decorator neq "">
			
				<cfsavecontent variable="decoratedLayout">
					<cfset target = view />
					<cfinclude template="#decorator#" />
				</cfsavecontent>
				
				<cfset tempFileName = CreateUUID( ) />
				<cffile action="write" output="#decoratedLayout#" file="ram://#tempFileName#.cfm" />
				<cfinclude template="/ram/#tempFileName#.cfm" />
				<cffile action="delete" file="ram://#tempFileName#.cfm" />
			<cfelse>
				<cfinclude template="#view#" />
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="GetDefaultAction" access="private" returntype="string" output="false">
		<cfargument name="controller" type="string" required="yes" />
		
		<cfset var meta   = GetComponentMetaData( "controllers." & arguments.controller ) />
		<cfset var action = "" />
		
		<cfif StructKeyExists( meta, "DEFAULTACTION" )>
			<cfset action = meta.defaultAction />
		<cfelseif StructKeyExists( meta, "extends" ) and StructKeyExists( meta.extends, "DEFAULTACTION" )>
			<cfset action = meta.extends.defaultAction />
		</cfif>
		
		<cfreturn action />		
	</cffunction>
	
	<cffunction name="GetLayout" access="private" returntype="string" output="false">
		<cfargument name="controller" type="string" required="yes" />
		<cfargument name="action" type="string" required="no" default="" />

		<cfset var decorator = "" />
		<cfset var meta      = GetComponentMetaData( "controllers." & arguments.controller ) />		

		<cfif arguments.action neq "">
			<cfloop array="#meta.functions#" index="func">
				<cfif func.name eq arguments.action>
					<cfif StructKeyExists( func, "layout" )>
						<cfset decorator = "/views/layouts/" & arguments.controller & "/" & func.layout & ".cfm" />
					</cfif>
					
				</cfif>
					
			</cfloop>		
		</cfif>
		
		<cfif decorator eq "" and StructKeyExists( meta, "layout" )>
		
			<!--- Get default layout if there is one --->
			<cfset decorator = "/views/layouts/" & meta.layout & ".cfm" />
		</cfif>
	
		<cfreturn decorator />
	</cffunction>
	
	<cfscript>	
		string function getLink( string controller = variables.controller, string action = "" ){
			var _action = arguments.action;
			var _url    = "";
			
			if ( _action neq "" ){
				_action = "/" & _action;
			};
			
			_url = cgi.SCRIPT_NAME & "/" & arguments.controller & _action;

			return _url;
		};
	</cfscript>
</cfcomponent>