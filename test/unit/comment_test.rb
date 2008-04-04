require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase

  context 'A Comment instance' do
    should_belong_to :commentable
    should_belong_to :profile
  end

  should "show me the wall between us" do
    comments = Comment.between_profiles profiles(:user), profiles(:user2)
    assert_equal 1, comments.size
    assert_equal [comments(:third).id], comments.map(&:id).sort

    assert profiles(:user).comments.create(:comment => 'yo', :profile => profiles(:user2))
    assert_equal 2, Comment.between_profiles( profiles(:user), profiles(:user2)).size
  end

  should "show me the wall between me" do
    comments = Comment.between_profiles profiles(:user), profiles(:user)
    assert_equal 1, comments.size
    assert_equal [comments(:seven).id], comments.map(&:id).sort
  end

  should 'create new feed_item and feeds after someone else creates a comment' do
    assert_difference "FeedItem.count", 1 do
      assert_difference "Feed.count", 2 do
        p = profiles(:user)
        assert p.comments.create(:comment => 'omg yay test!', :profile_id => profiles(:user2).id)
      end
    end
  end

  def test_associations
    _test_associations
  end
end