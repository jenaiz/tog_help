module HelpHelper
  include TogHelp::PagesCreator
  
  # Return link to a help page (create pages in CMS if needed)
  # 
  def link_to_help(cmspage=nil, name=I18n.t("tog_help.help"), options = {})
    path = get_help_path(cmspage)             
    link_to(name, cms_connect_path(path), options)
  end 

  # Return URL to a help page (create pages in CMS if needed)
  # 
  def help_page_path(cmspage=nil)
    path = get_help_path(cmspage)             
    cms_connect_path(path)
  end 

end
