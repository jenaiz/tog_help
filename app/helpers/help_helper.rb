module HelpHelper
  include TogHelp::PagesCreator
  
  # Return link to a help page (create pages in CMS if needed)
  # 
  def link_to_help(cmspage=nil, name=I18n.t("tog_help.help"), options = {})
    page = get_help_page(cmspage)             
    link_to(name, cms_connect_path(page.url), options)
  end 

  # Return URL to a help page (create pages in CMS if needed)
  # 
  def help_page_path(cmspage=nil)
    page = get_help_page(cmspage)             
    cms_connect_path(page.url)
  end 

end
