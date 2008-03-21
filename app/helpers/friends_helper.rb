module FriendsHelper
  def get_friend_link profile, target
    return wrap_get_friend_link(link_to('Sign-up to Follow', signup_path)) if profile.blank?
    return '' unless profile && target
    dom_id = profile.dom_id(target.dom_id + '_friendship_')
    return wrap_get_friend_link('') if profile == target
    return wrap_get_friend_link(link_to_remote( 'Stop Being Friends', :url => profile_friend_path(profile, target), :method => :delete), dom_id) if profile.friend_of? target
    return wrap_get_friend_link(link_to_remote( 'Stop Following', :url => profile_friend_path(profile, target), :method => :delete), dom_id) if profile.following? target
    return wrap_get_friend_link(link_to_remote( 'Be Friends', :url => profile_friends_path(target), :method => :post), dom_id) if profile.followed_by? target
    wrap_get_friend_link(link_to_remote( 'Start Following', :url => profile_friends_path(target), :method => :post), dom_id)
  end
  
  
  
  
  protected
  def wrap_get_friend_link str, dom_id = ''
    content_tag :span, str, :id=>dom_id, :class=>'friendship_description'
  end
end