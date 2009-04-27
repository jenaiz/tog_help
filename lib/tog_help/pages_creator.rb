module TogHelp
  module PagesCreator
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::TagHelper
    include TogHelp::Helper
     
    # Create pages tree given the path array or return existing one. 
    # Create all needed intermediate pages using the slug as 
    # default title, breadcrumb and content.
    #
    # Return last page
    #
    def create_help_tree(arypath)    
      # Page#find_by_url raises an exception when page not found
      begin    
        page = Page.find_by_url(arypath.join("/"))
        return page if page
      rescue
      end    
      last_page = arypath.inject(nil) do |parent, slug|
        page = Page.find_by_slug_and_parent_id(slug, parent)
        unless page
          page = Page.new(:title => slug.titleize, 
                          :slug => slug, 
                          :breadcrumb => slug.titleize, 
                          :content => slug , 
                          :parent => parent)
          page.save!
          page.published!
        end
        page
      end
      send_internal_message(last_page)
      last_page
    end  
      
    # Send internal message to active admins informing about a new created help page
    # Use first created admin as sender
    #
    def send_internal_message(page)
      admin_users = User.find_all_by_admin_and_state(true, 'active', 
        :order => 'created_at desc')
      admin_users.each do |user|
        message = Message.new(
          :from => admin_users.first,
          :to => user,
          :subject => I18n.t("tog_help.helpers.help_helper.subject"),      
          :content => '<br/>' + I18n.t("tog_help.notifier.mailer.text") + '<br/>' +
                      "%s (%s)" % [
                        link_to(cms_connect_url(page.url), cms_connect_url(page.url)),
                        link_to(I18n.t("tog_help.notifier.mailer.edit"), cms_page_edit_url(page))
                      ] + 
                      '<br/>' +
                      I18n.t("tog_help.notifier.mailer.bye")
        )
        message.dispatch!        
      end  
    end

    # Return true if string path seems a help page path
    #
    def is_a_help_page_path?(path_ary)
      help_path = get_initial_help_path.split("/").reject(&:empty?)
      path_ary.first(help_path.size) == help_path
    end
    
  end  
end
