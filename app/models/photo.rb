# == Schema Information
# Schema version: 2008100601002
#
# Table name: photos
#
#  id         :integer(4)    not null, primary key
#  caption    :string(1000)  
#  created_at :datetime      
#  updated_at :datetime      
#  profile_id :integer(4)    
#  image      :string(255)   
#


class Photo < ActiveRecord::Base
  
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'
  
  belongs_to :profile
  
  has_attached_file :image, :styles => { :square => "50x50#", :small => "175x250>"}, :path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension"
  
  validates_attachment_presence :image
  validates_presence_of :profile_id
  attr_immutable :id, :profile_id
  
  def after_create
    feed_item = FeedItem.create(:item => self)
    ([profile] + profile.friends + profile.followers).each{ |p| p.feed_items << feed_item }
  end
    
end
