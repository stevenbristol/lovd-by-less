class ProfilesController < ApplicationController
  include ApplicationHelper
  prepend_before_filter :get_profile, :except => [:new, :create, :index, :search]  
  before_filter :setup, :except => [:index, :search]
  before_filter :search_results, :only => [:index, :search]
  skip_filter :login_required, :only=>[:show, :index, :feed, :search]

  def show
    unless @profile.youtube_username.blank?
      begin
        client = YouTubeG::Client.new
        @video = client.videos_by(:user => @profile.youtube_username).videos.first
      rescue Exception, OpenURI::HTTPError
      end
    end
    
    begin
      @flickr = @profile.flickr_username.blank? ? [] : flickr_images(flickr.people.findByUsername(@profile.flickr_username))
    rescue Exception, OpenURI::HTTPError
      @flickr = []
    end
      
      

    @comments = @profile.comments.paginate(:page => @page, :per_page => @per_page)
    
    respond_to do |wants|
      wants.html do
        @feed_items = @profile.feed_items
      end
      wants.rss do 
        @feed_items = @profile.feed_items
        render :layout => false
      end
    end
  end
  
  def search
    render
  end
  
  def index
    render :action => :search
  end
  
  def edit
    render
  end
    
  
  def update
    case params[:switch]
    when 'name','image'
      if @profile.update_attributes params[:profile]
        flash[:notice] = "Settings have been saved."
        redirect_to edit_profile_url(@profile)
      else
        flash.now[:error] = @profile.errors
        render :action => :edit
      end
    when 'password'
      if @user.change_password(params[:verify_password], params[:new_password], params[:confirm_password])
        flash[:notice] = "Password has been changed."
        redirect_to edit_profile_url(@profile)
      else
        flash.now[:error] = @user.errors
        render :action=> :edit
      end
    else
      RAILS_ENV == 'test' ? render( :text=>'') : raise( 'Unsupported swtich in action')
    end
  end


  def delete_icon
    respond_to do |wants|
      @p.update_attribute :icon, nil
      wants.js {render :update do |page| page.visual_effect 'Puff', 'profile_icon_picture' end  }
    end      
  end



  def destroy
    respond_to do |wants|
     @user.destroy
      cookies[:auth_token] = {:expires => Time.now-1.day, :value => ""}
      session[:user] = nil
      wants.js do
        render :update do |page| 
          page.alert('Your user account, and all data, have been deleted.')
          page << 'location.href = "/";'
        end
      end
    end
  end





  private
  
  def allow_to
    super :owner, :all => true
    super :all, :only => [:show, :index, :search]
  end
  
  def get_profile
    @profile = Profile[params[:id]]
  end
  
  def setup
    @user = @profile.user
  end
  
  def search_results
    if params[:search]
      p = params[:search].dup
    else
      p = []
    end
    @results = Profile.search(p.delete(:q) || '')
  end
end
