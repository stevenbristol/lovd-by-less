##
# ForumPost class
# Author: Les Freeman (lesliefreeman3@gmail.com)
# Created on: 5/16/08
# Updated on: 5/16/08
#

class ForumPost < ActiveRecord::Base
  validates_presence_of :body, :owner_id
  
  belongs_to :owner, :class_name => "Profile"
  belongs_to :topic, :class_name => "ForumTopic"
  
  after_create :update_topic
  
private
  def update_topic
    topic.update_attributes({:updated_at => Time.now})
  end
  
end
