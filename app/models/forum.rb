# == Schema Information
# Schema version: 2008100601002
#
# Table name: forums
#
#  id          :integer(4)    not null, primary key
#  name        :string(255)   
#  description :text          
#  position    :integer(4)    
#  created_at  :datetime      
#  updated_at  :datetime      
#

class Forum < ActiveRecord::Base
  
  acts_as_list
  attr_immutable :id
  
  validates_presence_of :name
  
  has_many :topics, :class_name => "ForumTopic", :order => "updated_at DESC", :dependent => :destroy
  
  has_many :posts, :through => :topics
  
  def to_param
    "#{self.id}-#{name.to_safe_uri}"
  end
  
  
  def build_topic attributes
    topic = topics.build(attributes)
  end
  
  
  
  
  
end
