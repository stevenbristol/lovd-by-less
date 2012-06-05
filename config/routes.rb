LovdByLess::Application.routes.draw do

  namespace :admin do
    resources :users do
      collection { post :search }
    end
  end

  resources :profiles do
    member      { post :delete_icon }
    collection  { get :search }
    # FIXME: :has_many=>[:friends, :blogs, :photos, :comments, :feed_items, :messages]
  end

  resources :messages do
    collection { get :sent }
  end
  
  resources :blogs do
    resources :comments
  end
  
  resources :forums do
    collection { post :update_positions }
    resources :topics, :controller => :forum_topics do
      resources :posts, :controller => :forum_posts
    end
  end
  
  scope :controller => :accounts do
    get :login
    get :logout
    get :signup
  end
  
  scope :controller => :home do
    get :index, :as => :home
    get :latest_comments
    get :newest_members
    get :terms, :as => :tos
    get :contact
  end

end
