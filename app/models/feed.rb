# == Schema Information
# Schema version: 2008100601002
#
# Table name: feeds
#
#  id           :integer(4)    not null, primary key
#  profile_id   :integer(4)    
#  feed_item_id :integer(4)    
#

class Feed < ActiveRecord::Base
  belongs_to :feed_item
  belongs_to :profile
  attr_immutable :id, :profile_id, :feed_item_id
end
