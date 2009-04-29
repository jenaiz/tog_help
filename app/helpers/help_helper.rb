module HelpHelper
  include TogHelp::Helper
  
  # Return link to a help page
  # 
  def link_to_help(cmspage=nil, name=I18n.t("tog_help.help"), options = {})
    path = get_help_path(cmspage)             
    link_to(name, path, options)
  end 

  # Return facebox link to a help page
  def facebox_link_to_help(cmspage=nil, name=I18n.t("tog_help.help"), html_options = {})  
    facebox = render(:partial => 'shared/facebox')
    link = facebox_link_to(name, 
      :url => help_page_path(cmspage), 
      :method => :get,
      :html => html_options)
    facebox + link    
  end

  # Return URL to a help page
  # 
  def help_page_path(cmspage=nil)
    get_help_path(cmspage)             
  end 

end
