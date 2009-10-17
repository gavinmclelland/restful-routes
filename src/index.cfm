<h1>RESTful Routes Plugin</h1>
<p>The RESTful Routes Plugin allows you to create RESTful resources within your application.</p>
<h2>Basic Usage</h2>
<p>For an example, lets says that our controller will be named Instruments.cfc.
	First, to setup all of your routes for the instruments controller, simply add the line of code below to config/routes.cfm.</p>
<code>
	&lt;cfset addResources(name="instruments") /&gt;
</code>
<p></p>
<p>This call will setup the following URLs within your application.</p>

<ul>
	<li>
		<strong>/instruments</strong> which respond to two http methods:
		<ul>
			<li><strong>GET</strong> which is sent to the index() method of Instruments.cfc</li>
			<li><strong>POST</strong> which is sent to the new() method of Instruments.cfc</li>
		</ul> 
	</li>
	<li>
		<strong>/instruments/new</strong> which responds to one http method:
		<ul>
			<li><strong>GET</strong> which is sent to the new() method of Instruments.cfc</li>
		</ul> 
	</li>
	<li>
		<strong>/instruments/[key]</strong> which responds to three http methods:
		<ul>
			<li><strong>GET</strong> which is sent to the view() method of Instruments.cfc</li>
			<li><strong>PUT</strong> which is sent to the update() method of Instruments.cfc</li>
			<li><strong>DELETE</strong> which is sent to the destroy() method of Instruments.cfc</li>
		</ul> 
	</li>
	<li>
		<strong>/instruments/[key]/edit</strong> which responds to one http method:
		<ul>
			<li><strong>GET</strong> which is sent to the edit() method of Instruments.cfc</li>
		</ul> 
	</li>  
</ul>

<h2>Additional Options</h2>
<p>For more advaced usage, the RESTful Routes Plugin gives you the following additional options when calling addResources().</p>

<ul>
	<li><strong>path</strong> - the base url from which the resource will respond to.</li>
	<li><strong>controller</strong> - the controller to send the request to.</li>
	<li><strong>collections</strong> - a list of extra method used to display collections from your controller.</li>
	<li><strong>members</strong> - a list of extra method used to display a single item from your controller.</li>
	<li><strong>nested</strong> - a list of controller that should be nested within the named controller.</li>
</ul>

<h3>Path</h3>
<p>
	To build on the example above, say I would like the Instruments.cfc to be a part of my admin interface and that I want to URLs prefixed with /admin.
	RESTful Resources plugin, simply do the following.
</p>
<code>
	&lt;cfset addResources(name="instruments", path="admin/instruments") /&gt;
</code>
<p></p>

<h3>Controller</h3>
<p>
	If you would like the name of your route to be different from the controller name, simply pass in this argument with the proper controller name like so.
</p>
<code>
	&lt;cfset addResources(name="instruments", path="admin/instruments", controller="instrument") /&gt;
</code>
<p></p>

<h3>Collections</h3>
<p>
	To build on the example above, say I would like to have an action that <strong>lists</strong> all of the sold instruments. Since the action displays a collection
	we would pass that action name into the collections argument like so.
</p>
<code>
	&lt;cfset addResources(name="instruments", collections="sold") /&gt;
</code>
<p></p>
<p>This would then add an extra route to <strong>/instruments/sold</strong></p>

<h3>Members</h3>
<p>
	Members are the same as collections except they should only show a <strong>single item</strong>. So if I setup my resource with:
</p>
<code>
	&lt;cfset addResources(name="instruments" members="detail") /&gt;
</code>
<p></p>
<p>This would then add an extra route to <strong>/instruments/[key]/detail</strong></p>

<h3>Nested</h3>
<p>
	Say I can have repairs done on an instrument and would like to be able to see the repair history done for a particular instrument. There would be a repairs table
	that contains a foreign key to instruments. To represent this relation ship in the URL simply pass in the name of the
	controller to the nested argument like so.
</p>
<code>
	&lt;cfset addResources(name="instruments", nested="repairs") /&gt;
</code>
<p></p>
<p>In this instance, I would get a whole new set of routes for repairs on top of the instrument routes which includes:</p>

<ul>
	<li>
		<strong>/instruments/[instrumentsKey]/repairs</strong> which respond to two http methods:
		<ul>
			<li><strong>GET</strong> which is sent to the index() method of Repairs.cfc</li>
			<li><strong>POST</strong> which is sent to the new() method of Repairs.cfc</li>
		</ul> 
	</li>
	<li>
		<strong>/instruments/[instrumentsKey]/repairs/new</strong> which responds to one http method:
		<ul>
			<li><strong>GET</strong> which is sent to the new() method of Repairs.cfc</li>
		</ul> 
	</li>
	<li>
		<strong>/instruments/[instrumentsKey]/repairs/[key]</strong> which responds to three http methods:
		<ul>
			<li><strong>GET</strong> which is sent to the view() method of Repairs.cfc</li>
			<li><strong>PUT</strong> which is sent to the update() method of Repairs.cfc</li>
			<li><strong>DELETE</strong> which is sent to the destroy() method of Repairs.cfc</li>
		</ul> 
	</li>
	<li>
		<strong>/instruments/[instrumentsKey]/repairs/[key]/edit</strong> which responds to one http method:
		<ul>
			<li><strong>GET</strong> which is sent to the edit() method of Repairs.cfc</li>
		</ul> 
	</li>  
</ul>

<h2>Sending GET, POST, PUT and DELETE methods back to wheels</h2>
<p>The RESTful Routes plugin also helps you create links back to wheels. To do this, the plugin overrides the following public methods.</p>
<ul>
	<li>URLFor() - added functionality to handle the method argument.</li>
	<li>startFormTag() - added functionality to handle more options for the method argument.</li>
</ul>
<p>
	With RESTful Routes you can now add a method argument to linkTo(), buttonTo() and URLFor() with a value of either GET, POST, PUT or DELETE and the plugin will handle the rest.
	As a default, if you do not specify a method argument, GET is assumed to be the method chosen.</p>

<h2>Important</h2>
<p>
	RESTful Routes will only work with cfWheels 1.0 RC1. Please be aware that this plugin in not backward compatiable.
</p>

<h2>Road Map</h2>
<p>
	I would like to add the following features to the plugin to make it to a 1.0 release.
</p>
<ul>
	<li>Testing, testing, testing</li>
	<li>Deeper levels of nesting, currently the plugin only supports one nested level.</li>
	<li>Add features like routing based of of sub-domains and full domains.</li>
</ul>


<h2>Uninstallation</h2>
<p>To uninstall this plugin simply delete the <tt>/plugins/RESTfulRoutes-0.1.zip</tt> file.</p>

<h2>Credits</h2>
<p>This plugin was created by <a href="http://iamjamesgibson.com">James Gibson</a>.</p>

<p><a href="<cfoutput>#cgi.http_referer#</cfoutput>">&lt;&lt;&lt; Go Back</a></p>
