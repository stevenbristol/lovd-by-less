class Forum < ActiveRecord::Base
  
  acts_as_list
  
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
