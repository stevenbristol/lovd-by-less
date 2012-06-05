##
# ForumTopicTest
# Author: Les Freeman (lesliefreeman3@gmail.com)
# Created on: 5/16/08
# Updated on: 5/16/08
#

require 'test_helper'

class ForumTopicTest < ActiveSupport::TestCase
  
  # include ForumsTestHelper
  
  should validate_presence_of :title
  should validate_presence_of :forum_id
  should validate_presence_of :owner_id
  
  should belong_to :forum
  should belong_to :owner
  should have_many :posts
  
  should "create a feed item" do
    assert_difference "FeedItem.count" do
      topic = ForumTopic.new(valid_forum_topic_attributes)
      topic.save!
    end
  end
  
end
