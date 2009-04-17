class ChangeHelpPage < ActiveRecord::Migration
  def self.up
    
    # Destroing not only help page, but sons too
    help = Page.find(:first, :conditions => {:title => 'Help', :slug => 'help', :content => '<p>Help</p>' })    
    help.destroy
    
    help = Page.new(:title => 'Help', :slug => 'help', :breadcrumb => 'help', :state => 'published', 
                    :content => '<p>Help</p>')
    help.save!
    
    Tog::Plugins.settings :tog_help, {"initial_path" => "help"}, {:force => true} 
  end

  def self.down
    page = Page.find(:first, :conditions => ['slug = ? and breadcrumb = ?', 'help', 'help'])
    page.parent = home = Page.find(:first)    
    page.save!

    Tog::Plugins.settings :tog_help, {"initial_path" => "inicio/help/"}, {:force => true} 
    
  end
end