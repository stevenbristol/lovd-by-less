ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |a|
    a.resources :users, :collection => {:search => :post}
  end

  map.resources :profiles, 
  :member=>{:delete_icon=>:post}, :collection=>{:search=>:get}, 
  :has_many=>[:friends, :blogs, :photos, :comments, :feed_items, :messages]

  map.resources :messages, :collection => {:sent => :get}
  map.resources :blogs do |blog|
    blog.resources :comments
  end


  map.login   "/login",   :controller=>'accounts', :action => 'login'
  map.logout  "/logout",  :controller=>'accounts', :action => 'logout'
  map.signup  "/signup",  :controller=>'accounts', :action => 'signup'
  map.home '/', :controller=>'home', :action => 'index'
  map.latest_comments '/latest_comments.rss', :controller=>'home', :action => 'latest_comments', :format=>'rss'
  map.newest_members '/newest_members.rss', :controller=>'home', :action => 'newest_members', :format=>'rss'
  map.tos '/tos', :controller => 'home', :action => 'terms'
  map.contact '/contact', :controller => 'home', :action => 'contact'

end
