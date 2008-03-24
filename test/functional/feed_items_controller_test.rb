require File.dirname(__FILE__) + '/../test_helper'

class FeedItemsControllerTest < ActionController::TestCase
  
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
