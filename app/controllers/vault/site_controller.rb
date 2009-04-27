class Vault::SiteController < ApplicationController
  include TogHelp::PagesCreator
  before_filter :create_help_page, :only => :show_page
  
  private
  
  def create_help_page
    url = params[:url]
    url = url.split("/") unless url.is_a?(Array)
    create_tree(url) if is_a_help_page_path?(url)
  end
  
end
