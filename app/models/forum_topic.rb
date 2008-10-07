# == Schema Information
# Schema version: 2008100601002
#
# Table name: forum_topics
#
#  id         :integer(4)    not null, primary key
#  title      :string(255)   
#  forum_id   :integer(4)    
#  owner_id   :integer(4)    
#  created_at :datetime      
#  updated_at :datetime      
#

class ForumTopic < ActiveRecord::Base
  validates_presence_of :title, :owner_id, :forum_id
  attr_immutable :id, :forum_id, :owner_id
  
  belongs_to :owner, :class_name => "Profile"
  belongs_to :forum
  
  has_many :posts, :class_name => "ForumPost", :foreign_key => "topic_id", :dependent => :destroy
  
  def to_param
    "#{self.id}-#{title.to_safe_uri}"
  end
  
  def after_create
    feed_item = FeedItem.create(:item => self)
  end
  
  def users
    posts.collect{|p| p.owner.user}.uniq
  end
  
end
