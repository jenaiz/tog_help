module HelpHelper

  def link_to_help(cmspage=nil, name=I18n.t("tog_help.help"), options = {})
    locale = (I18n.default_locale || Tog::Config["plugins.tog_core.language.default"]).to_s
    initial_path = Tog::Config["plugins.tog_help.initial_path"] || "help"    
    initial_path = initial_path + '/' unless initial_path.ends_with?('/')     
    page = locale + '/' + controller.controller_path + '/' + controller.action_name

    link_page = ''
    if cmspage.nil?
      page = '/' + controller.controller_path + '/' + page.gsub('/', '_')
      link_page = initial_path + locale + page
      create_tree(initial_path, locale, page, cms_connect_path(link_page))      
    else
      link_page = initial_path + locale + '/' + cmspage
    end
    
    # when run from selenium tests the init.rb of tog_help does not seem to be run
    # and thus Tog::Config["plugins.tog_help.initial_path"] is not set
    link_to(name, cms_connect_path(link_page), options)
  end 
  
  def create_tree(initial_path, locale, page, link_page)
    route = initial_path + locale + page
    route.slice!(0) if route.starts_with?('/')
    routes = route.split('/').reject(&:empty?)
                             
    slug = routes.last
    page = Page.find_by_slug(slug)
    if page == nil
      parent = Page.find(:first, :conditions => {:slug => routes.first, :parent_id => nil})
      if !parent
        parent = page_from_parent(routes.first, routes.first, nil) 
      end
      tree = routes[1, routes.length]
      tree.each_index do |index|
        dir = Page.find(:first, :conditions => {:slug => tree[index], :parent_id => parent})   
        if dir == nil && (tree.last != tree[index])
          parent = page_from_parent(tree[index], tree[index], parent)
        elsif dir == nil && (tree.last == tree[index])
          parent = page_from_parent(tree[index], slug, parent)
        elsif dir != nil
          parent = dir
        end
      end
      send_internal_message(request.protocol + request.host_with_port + link_page)
    end
  end
  
  def page_from_parent(title, page, parent)
    new_page = Page.new(:title => title, :slug => page, :breadcrumb => page, 
                        :content => page, :parent => parent, :state => "published")
    new_page.save!    

    return new_page       
  end
  
  def send_internal_message(page_url)
    users = User.find(:all, :conditions => {:admin => true, :state => 'active'}, :order => 'created_at desc')
    
    users.each do |user|
      @message = Message.new(
          :from => users.first,
          :to => user,
          :subject => Tog::Config["plugins.tog_core.mail.default_subject"] + I18n.t("tog_help.helpers.help_helper.subject"),      
          :content => '<br/>' + I18n.t("tog_help.notifier.mailer.text") + '<br/>' +
                      link_to(page_url, page_url) + '<br/>' + 
                      I18n.t("tog_help.notifier.mailer.bye") 
      )
      @message.dispatch!
    end  
  end
end
