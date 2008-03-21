require File.dirname(__FILE__) + '/../test_helper'
require 'feed_items_controller'

# Re-raise errors caught by the controller.
class FeedItemsController; def rescue_action(e) raise e end; end

class FeedItemsControllerTest < ActionController::TestCase
  fixtures :users, :profiles, :feeds, :feed_items, :blogs, :photos, :comments
  
  def setup
    @controller = FeedItemsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  context 'on DELETE to :destroy while logged in as :owner' do
    should 'remove the feed_item from the database using html' do
      assert_difference "Feed.count", -1 do
        p = profiles(:user)
        f = feed_items(:one)
        delete :destroy, {:profile_id => p.id, :id => f.id}, {:user => p.id}
        assert_response :redirect
        assert_redirected_to profile_path(p)
      end
    end
    
    should 'remove the feed_item from the database using js' do
      assert_difference "Feed.count", -1 do
        p = profiles(:user)
        f = feed_items(:one)
        delete :destroy, {:profile_id => p.id, :id => f.id, :format => 'js'}, {:user => p.id}
        assert_response :success
      end
    end
  end
end
