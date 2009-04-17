require_plugin 'tog_vault'

require "i18n" unless defined?(I18n)
Dir[File.dirname(__FILE__) + '/locale/**/*.yml'].each do |file|
  I18n.load_path << file
end

Tog::Plugins.helpers HelpHelper

Tog::Plugins.settings :tog_help, "initial_path" => "help"