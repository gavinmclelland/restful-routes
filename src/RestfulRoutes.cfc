<cfcomponent>

	<cffunction name="init" output="false">
		<cfscript>
			this.version = "1.0";
		</cfscript>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addResources" mixin="global" output="false" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="path" type="string" required="false" default="#arguments.name#" />
		<cfargument name="controller" type="string" required="false" default="#capitalize(arguments.name)#" />
		<cfargument name="collections" type="string" required="false" default="" />
		<cfargument name="members" type="string" required="false" default="" />
		<cfargument name="nested" type="string" required="false" default="" />
		<cfscript>
			var loc = {};
			
			// setup our nested routes as they are the highest priority
			if (Len(arguments.nested)) {
			
				loc.nestedResourcesLen = ListLen(arguments.nested);
				for(loc.i=1; loc.i lte loc.nestedResourcesLen; loc.i++) {
				
					loc.nestedResource = ListGetAt(arguments.nested, loc.i);
					addResources(name=loc.nestedResource, path=arguments.path & "/[#arguments.controller#Key]/" & loc.nestedResource, controller=loc.nestedResource);
				}
			}
			
			arguments.members = ListAppend(arguments.members, "edit");
			
			addRoute(name=arguments.name, pattern=arguments.path & "/[key]/[action]", controller=arguments.controller, allowedActions=arguments.members, method="get", resource=true);
			
			if (Len(arguments.collections)) {
			
				loc.collectionsLen = ListLen(arguments.collections);
				for (loc.i=1; loc.i lte loc.collectionsLen; loc.i++) {
				
					loc.collection = ListGetAt(arguments.collections, loc.i);
					addRoute(name=arguments.name, pattern=arguments.path & "/" & loc.collection, controller=arguments.controller, action=loc.collection, method="get", resource=true);
				}
			}
			
			addRoute(name=arguments.name, pattern=arguments.path & "/new", controller=arguments.controller, action="new", method="get", resource=true);
			addRoute(name=arguments.name, pattern=arguments.path & "/[key]", controller=arguments.controller, action="destroy", method="delete", resource=true);
			addRoute(name=arguments.name, pattern=arguments.path & "/[key]", controller=arguments.controller, action="update", method="put", resource=true);
			addRoute(name=arguments.name, pattern=arguments.path & "/[key]", controller=arguments.controller, action="view", method="get", resource=true);
			addRoute(name=arguments.name, pattern=arguments.path, controller=arguments.controller, action="create", method="post", resource=true);
			addRoute(name=arguments.name, pattern=arguments.path, controller=arguments.controller, action="index", method="get", resource=true);
		</cfscript>
		<cfreturn />
	</cffunction>
		
	<cffunction name="isGet" mixin="global" returntype="boolean" output="false">
		<cfscript>
			var returnValue = "";
			if (cgi.request_method == "get")
				returnValue = true;
			else
				returnValue = false;
		</cfscript>
		<cfreturn returnValue>
	</cffunction>
	
	<cffunction name="isPost" mixin="global" returntype="boolean" output="false">
		<cfscript>
			var returnValue = "";
			if (cgi.request_method == "post")
				returnValue = true;
			else
				returnValue = false;
		</cfscript>
		<cfreturn returnValue>
	</cffunction>
	
	<cffunction name="isPut" mixin="global" returntype="boolean" output="false">
		<cfscript>
			var returnValue = false;
			if ((StructKeyExists(url, "_method") and url["_method"] eq "put") or (StructKeyExists(form, "_method") and form["_method"] eq "put"))
				returnValue = true;
		</cfscript>
		<cfreturn returnValue />
	</cffunction>
	
	<cffunction name="isDelete" mixin="global">
		<cfscript>
			var returnValue = false;
			if ((StructKeyExists(url, "_method") and url["_method"] eq "delete") or (StructKeyExists(form, "_method") and form["_method"] eq "delete"))
				returnValue = true;
		</cfscript>
		<cfreturn returnValue />
	</cffunction>

	<cffunction name="URLFor" mixin="global" returntype="string" output="false">
		<cfargument name="route" type="string" required="false" default="" hint="Name of a route that you have configured in 'config/routes.cfm'">
		<cfargument name="controller" type="string" required="false" default="" hint="Name of the controller to include in the URL">
		<cfargument name="action" type="string" required="false" default="view" hint="Name of the action to include in the URL">
		<cfargument name="method" type="string" required="false" default="" hint="">
		<cfargument name="key" type="any" required="false" default="" hint="Key(s) to include in the URL">
		<cfargument name="params" type="string" required="false" default="" hint="Any additional params to be set in the query string">
		<cfargument name="anchor" type="string" required="false" default="" hint="Sets an anchor name to be appended to the path">
		<cfargument name="onlyPath" type="boolean" required="false" default="#application.wheels.functions.URLFor.onlyPath#" hint="If true, returns only the relative URL (no protocol, host name or port)">
		<cfargument name="host" type="string" required="false" default="#application.wheels.functions.URLFor.host#" hint="Set this to override the current host">
		<cfargument name="protocol" type="string" required="false" default="#application.wheels.functions.URLFor.protocol#" hint="Set this to override the current protocol">
		<cfargument name="port" type="numeric" required="false" default="#application.wheels.functions.URLFor.port#" hint="Set this to override the current port number">
		<cfset var originalURLFor = core.URLFor />
		<cfreturn originalURLFor(argumentCollection=$checkMethod(argumentCollection=arguments)) />
	</cffunction>

	<cffunction name="startFormTag" mixin="application,controller,dispatch" returntype="string" output="false">
		<cfargument name="method" type="string" required="false" default="#application.wheels.functions.startFormTag.method#" hint="The type of method to use in the form tag, `get` and `post` are the options">
		<cfargument name="multipart" type="boolean" required="false" default="#application.wheels.functions.startFormTag.multipart#" hint="Set to `true` if the form should be able to upload files">
		<cfargument name="spamProtection" type="boolean" required="false" default="#application.wheels.functions.startFormTag.spamProtection#" hint="Set to `true` to protect the form against spammers (done with Javascript)">
		<cfargument name="route" type="string" required="false" default="" hint="See documentation for `URLFor`">
		<cfargument name="controller" type="string" required="false" default="" hint="See documentation for `URLFor`">
		<cfargument name="action" type="string" required="false" default="" hint="See documentation for `URLFor`">
		<cfargument name="key" type="any" required="false" default="" hint="See documentation for `URLFor`">
		<cfargument name="params" type="string" required="false" default="" hint="See documentation for `URLFor`">
		<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for `URLFor`">
		<cfargument name="onlyPath" type="boolean" required="false" default="#application.wheels.functions.startFormTag.onlyPath#" hint="See documentation for `URLFor`">
		<cfargument name="host" type="string" required="false" default="#application.wheels.functions.startFormTag.host#" hint="See documentation for `URLFor`">
		<cfargument name="protocol" type="string" required="false" default="#application.wheels.functions.startFormTag.protocol#" hint="See documentation for `URLFor`">
		<cfargument name="port" type="numeric" required="false" default="#application.wheels.functions.startFormTag.port#" hint="See documentation for `URLFor`">
		<cfscript>
			var originalStartFormTag = core.startFormTag;
		</cfscript>
		<cfreturn Replace(originalStartFormTag(argumentCollection=arguments), "method=""#arguments.method#""", "method=""post""", "all") />
	</cffunction>
	
	<cffunction name="$checkMethod" returntype="struct" output="false">
		<cfscript>
			// we the developer has not specified a method, then we assume it is a get
			if (not Len(arguments.method))
				arguments.method = "get";
		
			// since browsers don't yet understand put/delete requests, we fake them with _method= in the url for form scope
			if (ListFindNoCase("put,delete", arguments.method))
				if (not Len(arguments.params))
					arguments.params = "_method=" & arguments.method;
				else
					arguments.params = ListAppend(arguments.params, "_method=" & arguments.method, "&amp;");
		</cfscript>
		<cfreturn arguments />
	</cffunction>
	
	<cffunction name="$findMatchingRoute" mixin="dispatch" returntype="struct" access="public" output="false">
		<cfargument name="route" type="string" required="true">
		<cfargument name="routes" type="array" required="false" default="#application.wheels.routes#">
		<cfscript>
			var loc = {};
			
			$dump(arguments,false);
			
			// $findMatchingRoute now checks to make sure the method (ie get, post, put, delete) is correct along with matching a route
			
			loc.iEnd = ArrayLen(arguments.routes);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.routeStruct = arguments.routes[loc.i];
				loc.currentRoute = loc.routeStruct.pattern;
				
				// still make sure we have the right length route
				if (arguments.route == "" && loc.currentRoute == "")
				{
					loc.returnValue = arguments.routes[loc.i];
					break;
				}
				else 
				{
					loc.match = { method=false, variables=true};
					if (ListLen(arguments.route, "/") gte ListLen(loc.currentRoute, "/") && loc.currentRoute != "")
					{
						// check for matching variables
						loc.jEnd = ListLen(loc.currentRoute, "/");
						for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
						{
							loc.item = ListGetAt(loc.currentRoute, loc.j, "/");
							loc.thisRoute = ReplaceList(loc.item, "[,]", ",");
							loc.thisURL = ListGetAt(arguments.route, loc.j, "/");
							if (Left(loc.item, 1) != "[" && loc.thisRoute != loc.thisURL)
								loc.match.variables = false;
						}
						
						// now check to make sure the method is correct, skip this if not definied for the route
						if (StructKeyExists(loc.routeStruct, "method")) {
							loc.method = loc.routeStruct.method;
							if (loc.method eq "get" and isGet())
								loc.match.method = true;
							else if (loc.method eq "post" and isPost())
								loc.match.method = true;
							else if (loc.method eq "put" and isPut())
								loc.match.method = true;
							else if (loc.method eq "delete" and isDelete())
								loc.match.method = true;
						} else {
							// assume that the method is correct if not provided
							loc.match.method = true;
						}
						
						if (loc.match.method and loc.match.variables)
						{
							loc.returnValue = arguments.routes[loc.i];
							break;
						}
					}
				}
			}
			if (!StructKeyExists(loc, "returnValue"))
				$throw(type="Wheels.RouteNotFound", message="Wheels couldn't find a route that matched this request.", extendedInfo="Make sure there is a route setup in your 'config/routes.cfm' file that matches the '#arguments.route#' request.");
			</cfscript>
			<cfreturn loc.returnValue>
	</cffunction>	

	<cffunction name="$findRoute" returntype="struct" access="public" output="false">
		<cfscript>
			var loc = {};
			//$dump(arguments, false);
			loc.routePos = application.wheels.namedRoutePositions[arguments.route];
			if (loc.routePos Contains ",")
			{
				// there are several routes with this name so we need to figure out which one to use by checking the passed in arguments
				loc.iEnd = ListLen(loc.routePos);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.returnValue = application.wheels.routes[ListGetAt(loc.routePos, loc.i)];
					
					loc.match = {method=false, action=false, variables=true};
					
					loc.foundRoute = false;
					
					if (StructKeyExists(loc.returnValue, "method") and StructKeyExists(arguments, "method") and loc.returnValue.method eq arguments.method)
						loc.match.method = true;
					
					loc.jEnd = ListLen(loc.returnValue.variables);
					for (loc.j=1; loc.j <= loc.jEnd; loc.j++) {
					
						loc.variable = ListGetAt(loc.returnValue.variables, loc.j);
						
						if (loc.variable eq "action" and StructKeyExists(arguments, loc.variable) and Len(arguments[loc.variable]))
							loc.match.action = true;
							
						if (!StructKeyExists(arguments, loc.variable) or !Len(arguments[loc.variable]))
							loc.match.variables = false;
					}
						
					if (Len(arguments.action) and Len(loc.returnValue.action) and loc.returnValue.action eq arguments.action)
						loc.match.action = true;
						
					if (ListFindNoCase("view,index,destroy,update", loc.returnValue.action) and (not Len(arguments.action) or loc.returnValue.action eq arguments.action))
						loc.match.action = true;
					
					if (loc.match.method and loc.match.variables and loc.match.action)
						loc.foundRoute = true;
					
					//$dump(loc, false);
					if (loc.foundRoute)
						break;
				}
				//$abort();
			}
			else
			{
				loc.returnValue = application.wheels.routes[loc.routePos];
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

</cfcomponent>