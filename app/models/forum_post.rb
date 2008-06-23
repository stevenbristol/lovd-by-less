# == Schema Information
# Schema version: 2
#
# Table name: forum_posts
#
#  id         :integer(11)   not null, primary key
#  body       :text          
#  owner_id   :integer(11)   
#  topic_id   :integer(11)   
#  created_at :datetime      
#  updated_at :datetime      
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
