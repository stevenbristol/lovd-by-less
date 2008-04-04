module HomeHelper
  
  def newest_pictures limit = 12
    Photo.find(:all, :order => 'created_at desc', :limit => limit)
  end
  
  
  def recent_comments limit = 10
    Comment.find(:all, :order => 'created_at desc', :limit => limit, :conditions => "commentable_type='Profile'")
  end
  
  def new_members(limit = 12)
    Profile.find(:all, :limit => limit, :order => 'created_at DESC', :conditions=>"user_id is not null")
  end
  
  
  
  
end
