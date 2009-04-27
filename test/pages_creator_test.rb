require File.dirname(__FILE__) + '/test_helper'

# Mock *url methods used by internal message
TogHelp::PagesCreator.module_eval do 
  def cms_connect_url(*args)
    "cms_connect_url: #{args}"
  end
  def cms_page_edit_url(*args)
    "cms_page_edit_url: #{args}"
  end
end

class PagesCreatorTest < Test::Unit::TestCase
  include TogHelp::PagesCreator
 
  context "Help initial path: /help" do
    def setup
      Tog::Config["plugins.tog_help.initial_path"] = "/help"
    end
  
    should "check if a path is a help path" do
      assert is_a_help_page_path?(["help", "path1"])       
      assert is_a_help_page_path?(["help", "path1", "path2"])
      assert !is_a_help_page_path?(["path1", "help", "path2"])
    end
    
    context '2 active admin users' do
      setup do
        admin1 = Factory(:user, :login => 'admin1', :admin => true)
        admin1.activate!      
        admin2 = Factory(:user, :login => 'admin2', :admin => true)
        admin2.activate!
        @admins = [admin1, admin2]
        Page.delete_all
      end
          
      should "get non existing help page notifying admins" do
        Message.any_instance.expects(:dispatch!).twice
        page = create_help_tree(["help", "en", "page1", "page2"])
        assert_equal "help/en/page1/page2/", page.url
        assert_equal 'published', page.state
      end
      
      context 'existing help page' do
        setup do
          @page = create_help_tree(["help", "en", "page1", "page2"])
        end 
        should "get existing help page (without notifying admins)" do
          Message.any_instance.expects(:dispatch!).never
          page = create_help_tree(["help", "en", "page1", "page2"])
          assert_equal @page, page
          assert_equal "help/en/page1/page2/", page.url
          assert_equal 'published', page.state
        end
      end
    end
  end
end
