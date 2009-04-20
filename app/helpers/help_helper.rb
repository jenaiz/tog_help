module HelpHelper

  def link_to_help(cmspage=nil, name=I18n.t("tog_help.help"), options = {})

    locale = (I18n.default_locale || Tog::Config["plugins.tog_core.language.default"]).to_s
    initial_path = Tog::Config["plugins.tog_help.initial_path"] || "help"    
    initial_path = initial_path + '/' unless initial_path.ends_with?('/') 
    page = initial_path + controller.controller_path + '/' + controller.action_name
    
    if cmspage.nil?
      link_page = initial_path + locale + '/' + controller.controller_path + '/' + page.gsub('/', '_')
      create_tree(page, cms_connect_path(link_page))      
    else
      link_page = initial_path + locale + '/' + cmspage
    end
    
    # when run from selenium tests the init.rb of tog_help does not seem to be run
    # and thus Tog::Config["plugins.tog_help.initial_path"] is not set
    link_to(name, cms_connect_path(link_page), options)
  end 
  
  def create_tree(route, link_page)     
    route_z = route.gsub('/', '_')
    routes = route.split('/').reject(&:empty?)
    page = Page.find_by_slug(route_z)
    
    if page == nil
      routes.each_index do |index|
        dir = Page.find_by_slug(routes[index])
        if dir == nil && !(routes.last == routes[index])
          parent = (routes[index] == routes.first ? 'help' : routes[index - 1])
          page_from_parent(routes[index], routes[index], parent)
          #Notifier.deliver_created_new_page(link_page)
          send_internal_message(link_page)
        elsif dir == nil && (routes.last == routes[index])
          page_from_parent(routes[index], route_z, routes[index - 1])
          #Notifier.deliver_created_new_page(link_page)          
          send_internal_message(link_page)          
        end      
      end
    end
  end
  
  def page_from_parent(title, page, parent)
    father = Page.find_by_slug(parent)
    
    new_page = Page.new(:title => title, :slug => page, :breadcrumb => page, 
                        :content => page, :parent => father, :state => "published")

    new_page.save!
  end
  
  def send_internal_message(page_url)
    users = User.find(:all, :conditions => {:admin => true, :state => 'active'})
   
    users.each do |user|
      @message = Message.new(
          :from => current_user,
          :to => user,
          :subject => Tog::Config["plugins.tog_core.mail.default_subject"] + I18n.t("tog_help.helpers.help_helper.subject"),      
          :content => I18n.t("tog_help.notifier.mailer.hi") + '<br/>' + I18n.t("tog_help.notifier.mailer.text") + '<br/>' +
                      link_to(page_url, page_url) + '<br/>' + 
                      I18n.t("tog_help.notifier.mailer.bye") 
      )
      @message.dispatch!
    end
  end
end
