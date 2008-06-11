##
# Forum Class
# Author: Les Freeman (lesliefreeman3@gmail.com)
# Created on: 5/16/08
# Updated on: 5/16/08
#

class Forum < ActiveRecord::Base
  
  acts_as_list
  
  validates_presence_of :name
  
  has_many :topics, :class_name => "ForumTopic", :order => "updated_at DESC"
  
  has_many :posts, :through => :topics
  
  def to_param
    "#{self.id}-#{name.to_safe_uri}"
  end
  
end
