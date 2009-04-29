Tog Help
========

A plugin to manage help for applications.

== Included functionality

* Link to the help page.

Resources
=========

Plugin requirements
-------------------

You need to install another tog platform plugin:
In case you haven't installed any of them previously you'll need the following plugins:

* [tog\_vault](http://github.com/tog/tog_vault/blob/master/README.markdown)
* [facebox_render](http://github.com/ihower/facebox_render/)

Follow each link above for a short installation guide incase you have to install them.			

Install
-------

* Install plugin form source:

<pre>
ruby script/plugin install git://github.com/jenaiz/tog_help.git
</pre>

* Generate installation migration:

<pre>
ruby script/generate migration install_tog_help
</pre>

with the following content:

<pre>
class InstallTogHelp < ActiveRecord::Migration
  def self.up
    migrate_plugin "tog_help", 1
  end

  def self.down
    migrate_plugin "tog_help", 0
  end
end
</pre>

* And...

<pre> 
rake db:migrate
</pre> 

You only have to put a link in your views and you automaticaly will have a new CMS page with the name.:

<pre>
<%= link_to_help %>
</pre>

For example, if you visit the /home/index the new page will be in:

<pre>
  /cms/inicio/help/{locale}/home/es_home_index  
</pre>

Other examples of use:

<pre>
  link_to_help(cmspage, name, options = {})
</pre>

The helper define the params:

* cmspage: if it isn't nil, the link go to this cms page.
* name: if you don't want to use the text by default: I18n.t("tog_help.help"), you can use your own text.
* options: They are html_options like: class, etc.

<pre>
<%= link_to_help('my_own_page', 'help') %>
</pre>

<pre>
<%= link_to_help('') %>
</pre>

By default the plugin has the propeties:

<pre>
Tog::Config["plugins.tog_help.initial_path"] => "inicio/help/"
</pre> 

You can change it to your personal path.

Copyright (c) 2009 , released under the MIT license
