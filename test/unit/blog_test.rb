require File.dirname(__FILE__) + '/../test_helper'

class BlogTest < ActiveSupport::TestCase

  should 'create new feed_item and feeds after creating a blog post' do
    assert_difference "FeedItem.count" do
      assert_difference "Feed.count", 2 do
        p = profiles(:user)
        assert p.blogs.create(:title => 'this is a test post', :body => 'omg yay test!')
      end
    end
  end



  def test_associations
    _test_associations
  end
end
