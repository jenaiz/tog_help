require_plugin 'tog_vault'

require "i18n" unless defined?(I18n)
Dir[File.dirname(__FILE__) + '/locale/**/*.yml'].each do |file|
  I18n.load_path << file
end

#Tog::Interface.sections(:site).add "Blogs", "/blogs"
#
#Tog::Interface.sections(:member).add "Blogs", "/member/conversatio/blogs"
#
Tog::Plugins.helpers HelpHelper
#
#Tog::Search.sources << "Post"
#Tog::Search.sources << "Blog"

Tog::Plugins.settings :tog_help, "initial_path" => "inicio/help/"