module TogHelp
  module Helper
    
    protected
          
    # Get a help page from current controller/action names 
    # Use argument cmspage to override
    #
    # Return path to help page
    #
    def get_help_path(cmspage)
      locale = (I18n.default_locale || 
                Tog::Config["plugins.tog_core.language.default"]).to_s
      initial_path = get_initial_help_path
      path = if cmspage
        [initial_path, locale, cmspage]
      else
        [initial_path, locale, controller.controller_path, controller.action_name]
      end.map { |s| s.split("/") }.flatten.join("/")
      cms_connect_path(path)
    end

    # Return initial path for help pages (home/help by default)
    #
    def get_initial_help_path
      Tog::Config["plugins.tog_help.initial_path"] || "home/help"
    end
            
  end  
end
