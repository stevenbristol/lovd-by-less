##
# ForumTopic
# Author: Les Freeman (lesliefreeman3@gmail.com)
# Created on: 5/16/08
# Updated on: 5/16/08
# Provides useful methods for testing the models and controllers associented with forums.
#

class ForumTopic < ActiveRecord::Base
  validates_presence_of :title, :owner_id, :forum_id
  
  belongs_to :owner, :class_name => "Profile"
  belongs_to :forum
  
  has_many :posts, :class_name => "ForumPost", :foreign_key => "topic_id"
  
  def to_param
    "#{self.id}-#{title.to_safe_uri}"
  end
  
  def after_create
    feed_item = FeedItem.create(:item => self)
    ([owner] + owner.friends + owner.followers).each{ |p| p.feed_items << feed_item }
  end
  
end
