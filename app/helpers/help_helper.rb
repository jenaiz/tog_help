module HelpHelper

  def link_to_help(style="help")

    locale = (I18n.default_locale || Tog::Config["plugins.tog_core.language.default"]).to_s
    page = locale + '/' + controller.controller_path + '/' + controller.action_name
    
    create_tree(page)
    link_page = locale + '/' + controller.controller_path + '/' + page.gsub('/', '_')
    
    # when run from selenium tests the init.rb of tog_help does not seem to be run
    # and thus Tog::Config["plugins.tog_help.initial_path"] is not set
    initial_path = Tog::Config["plugins.tog_help.initial_path"] || "inicio/help/"
    link_to(I18n.t("tog_help.help"), cms_connect_path(initial_path + link_page), :class => style)
  end 
  
  def create_tree(route)
    route_z = route.gsub('/', '_')
    routes = route.split('/')
    page = Page.find_by_slug(route_z)
    
    if page == nil
      routes.each_index do |index|
        dir = Page.find_by_slug(routes[index])
        if dir == nil && !(routes.last == routes[index])
          parent = (routes[index] == routes.first ? 'help' : routes[index - 1])
          page_from_parent(routes[index], routes[index], parent)
        elsif dir == nil && (routes.last == routes[index])
          page_from_parent(routes[index], route_z, routes[index - 1])
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
      
end
