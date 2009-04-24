module TogHelp
  module PagesCreator
  
    protected
    
    # Get a help page from current controller/action names (
    # Use argument cmspage to override
    #
    def get_help_page(cmspage, default_initial_path = "home/help")
      locale = (I18n.default_locale || 
                Tog::Config["plugins.tog_core.language.default"]).to_s
      initial_path = Tog::Config["plugins.tog_help.initial_path"] || 
                     default_initial_path
      arypath = if cmspage
        [initial_path, locale, cmspage]
      else
        [initial_path, locale, controller.controller_path, controller.action_name]
      end.map { |s| s.split("/") }.flatten
      create_tree(arypath)
    end
    
    # Create pages tree for a path array. Create all needed intermediate
    # pages using the slug as default title, breadcrumb and content.
    #
    # Return last page
    #
    def create_tree(arypath)    
      # Page#find_by_url raises an exception if not found
      begin    
        return Page.find_by_url(arypath.join("/"))
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
          :subject => Tog::Config["plugins.tog_core.mail.default_subject"] + 
                      I18n.t("tog_help.helpers.help_helper.subject"),      
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
  end  
end
