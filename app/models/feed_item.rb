# == Schema Information
# Schema version: 2008100601002
#
# Table name: feed_items
#
#  id               :integer(4)    not null, primary key
#  include_comments :boolean(1)    not null
#  is_public        :boolean(1)    not null
#  item_id          :integer(4)    
#  item_type        :string(255)   
#  created_at       :datetime      
#  updated_at       :datetime      
#

class FeedItem < ActiveRecord::Base  
  belongs_to :item, :polymorphic => true
  has_many :feeds
  attr_immutable :id, :item_id, :item_type
  
  def partial
    item.class.name.underscore
  end
end
