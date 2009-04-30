module HelpHelper
  include TogHelp::Helper
  
  # Return link to a help page
  # 
  def link_to_help(cmspage=nil, name=I18n.t("tog_help.help"), options = {})
    path = get_help_path(cmspage)             
    link_to(name, path, options)
  end 

  # Return URL to a help page
  # 
  def help_page_path(cmspage=nil)
    get_help_path(cmspage)             
  end 

end
