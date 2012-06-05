##
# Forums tests
# Author: Les Freeman (lesliefreeman3@gmail.com)
# Created on: 5/16/08
# Updated on: 5/16/08
# 

require 'test_helper'

class ForumTest < ActiveSupport::TestCase
  
  #include ForumsTestHelper
  
  context "A Forum instance" do
    
    should validate_presence_of :name
    should have_many :topics
    should have_many :posts
  
    context ".build_topic" do
      should "return a ForumTopic" do
        topic = forums(:one).build_topic(valid_forum_topic_attributes)
        assert_kind_of ForumTopic, topic
        assert_equal forums(:one), topic.forum
      end
    end
  
  end
  
end
