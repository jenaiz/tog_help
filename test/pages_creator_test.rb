require File.dirname(__FILE__) + '/test_helper'

# Mock link_to
module TogHelp
  module PagesCreator
    def cms_connect_url(*args)
      "cms_connect_url: #{args}"
    end
    def cms_page_edit_url(*args)
      "cms_page_edit_url: #{args}"
    end
  end
end

module TogHelp
  class PagesCreatorTest < Test::Unit::TestCase
    include TogHelp::PagesCreator
          
    context '2 active admin users' do
      setup do
        admin1 = Factory(:user, :login => 'admin1', :admin => true)
        admin1.activate!      
        admin2 = Factory(:user, :login => 'admin2', :admin => true)
        admin2.activate!
        @admins = [admin1, admin2]
        Page.delete_all
      end
          
      should "get non-existing help page notifying admins" do
        Message.any_instance.expects(:dispatch!).twice
        path = get_help_path(["home", "help", "en", "page1", "page2"])
        page = create_tree(path.split("/"))
        assert_equal "help/es/home/help/en/page1/page2/", page.url
        assert_equal 'published', page.state
      end
      
      context 'existing help page' do
        setup do
          path = get_help_path(["home", "help", "en", "page1", "page2"])
          @page = create_tree(path.split("/"))        
        end 
        should "get existing help page (without notifying admins)" do
          Message.any_instance.expects(:dispatch!).never
          path = get_help_path(["home", "help", "en", "page1", "page2"])
          page = create_tree(path.split("/"))
          assert_equal @page, page
          assert_equal "help/es/home/help/en/page1/page2/", page.url
          assert_equal 'published', page.state
        end
      end

    end
  end
end
