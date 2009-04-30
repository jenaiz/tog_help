class Vault::SiteController < ApplicationController
  include TogHelp::PagesCreator
  before_filter :create_help_page, :only => :show_page
  
  private

  # Create help page (and tree) if it does not already exists  
  def create_help_page
    url = params[:url]
    url = url.split("/") unless url.is_a?(Array)
    create_help_tree(url) if is_a_help_page_path?(url)
  end
  
end
