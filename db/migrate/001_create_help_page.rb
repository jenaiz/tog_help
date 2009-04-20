class CreateHelpPage < ActiveRecord::Migration
  def self.up

    home = Page.find_by_parent_id(nil)

    page = Page.new
    page.title = 'Help'
    page.slug = 'help'
    page.breadcrumb = 'help'
    page.content = '<p>Help</p>'
    page.parent = home
    page.state = "published"
    page.save!    
  end

  def self.down
    page = Page.find(:first, :conditions => ['slug = ?', 'help'])
    page.destroy if page
  end
end