# == Schema Information
# Schema version: 2008100601002
#
# Table name: friends
#
#  id         :integer(4)    not null, primary key
#  inviter_id :integer(4)    
#  invited_id :integer(4)    
#  status     :integer(4)    default(0)
#  created_at :datetime      
#  updated_at :datetime      
#

class Friend < ActiveRecord::Base
  
  belongs_to :inviter, :class_name => 'Profile'
  belongs_to :invited, :class_name => 'Profile'
  
  after_create :create_feed_item
  after_update :create_feed_item
  attr_immutable :id, :invited_id, :inviter_id
  
  # Statuses Array
  
  ACCEPTED = 1
  PENDING = 0
  
  def create_feed_item
    feed_item = FeedItem.create(:item => self)
    inviter.feed_items << feed_item
    invited.feed_items << feed_item
  end
    
  def validate
    errors.add('inviter', 'inviter and invited can not be the same user') if invited == inviter
  end
  
  def description user, target = nil
    return 'friend' if status == ACCEPTED
    return 'follower' if user == inviter
    'fan'
  end
  
  def after_create
    AccountMailer.deliver_follow inviter, invited, description(inviter)
  end
  
  
  class << self
    
  


    def add_follower(inviter, invited)
      a = Friend.create(:inviter => inviter, :invited => invited, :status => PENDING)
#      logger.debug a.errors.inspect.blue
      !a.new_record?
    end
  
  
    def make_friends(user, target)
      transaction do
        begin
          Friend.find(:first, :conditions => {:inviter_id => user.id, :invited_id => target.id, :status => PENDING}).update_attribute(:status, ACCEPTED)
          Friend.create!(:inviter_id => target.id, :invited_id => user.id, :status => ACCEPTED)
        rescue Exception
          return make_friends( target, user) if user.followed_by? target
          return add_follower(user, target)
        end
      end
      true
    end
    
  
    def stop_being_friends(user, target)
    transaction do
      begin
        Friend.find(:first, :conditions => {:inviter_id => target.id, :invited_id => user.id, :status => ACCEPTED}).update_attribute(:status, PENDING)
          f = Friend.find(:first, :conditions => {:inviter_id => user.id, :invited_id => target.id, :status => ACCEPTED}).destroy
        rescue Exception
          return false
        end
      end
      true
    end
    
    
    def reset(user, target)
      #don't need a transaction here. if either fail, that's ok
      begin
        Friend.find(:first, :conditions => {:inviter_id => user.id, :invited_id => target.id}).destroy
        Friend.find(:first, :conditions => {:inviter_id => target.id, :invited_id => user.id, :status => ACCEPTED}).update_attribute(:status, PENDING)
      rescue Exception
        return true # we need something here for test coverage
      end
      true
    end
  
  
  end
  
end
