##
# ForumTopicTest
# Author: Les Freeman (lesliefreeman3@gmail.com)
# Created on: 5/16/08
# Updated on: 5/16/08
#

require File.dirname(__FILE__) + '/../test_helper'

class ForumTopicTest < ActiveSupport::TestCase
  
  include ForumsTestHelper
  
  should_require_attributes :title, :forum_id, :owner_id
  
  should_belong_to :forum, :owner
  should_have_many :posts
  
  should "create a feed item" do
    assert_difference "FeedItem.count" do
      topic = ForumTopic.new(valid_forum_topic_attributes)
      topic.save!
    end
  end
  
end
