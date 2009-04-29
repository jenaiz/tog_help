class Vault::SiteController < ApplicationController
  include TogHelp::PagesCreator
  include FaceboxRender
  before_filter :create_help_page, :only => :show_page
  
  private
  
  def create_help_page
    url = params[:url]
    url = url.split("/") unless url.is_a?(Array)
    create_help_tree(url) if is_a_help_page_path?(url)
  end

  def show_uncached_page(url)
    @page = find_page(url)
    respond_to do |format|
      format.js do
        errmsg = "<div class=\"error\">#{I18n.t("tog_help.help_not_found")}</div>"
        msg = @page ? nil : errmsg
        render_to_facebox :template => 'vault/site/show_page_facebox', :msg => msg 
      end
      format.html do
        if @page
          render
        else
          render :template => 'site/not_found', :status => 404
        end
      end
    end    
  end
  
end
