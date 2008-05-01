class BlogsController < ApplicationController
  skip_filter :login_required, :only => [:index, :show]
  prepend_before_filter :get_profile
  before_filter :setup
  
  
  def index
    if @p && @p == @profile && @p.blogs.empty?
      flash[:notice] = 'You have not create any blog posts.  Try creating one now.'
      redirect_to new_profile_blog_path(@p) and return
    end
    respond_to do |wants|
      wants.html {render}
      wants.rss {render :layout=>false}
    end
  end
  
  
  
  def create
    @blog = @p.blogs.build params[:blog]
    
    respond_to do |wants|
      if @blog.save
        wants.html do
          flash[:notice] = 'New blog post created.'
          redirect_to profile_blogs_path(@p)
        end
      else
        wants.html do
          flash.now[:error] = 'Failed to create a new blog post.'
          render :action => :new
        end
      end
    end
  end
  
  def show
    render
  end
  
  def edit
    render
  end
  
  def update
    respond_to do |wants|
      if @blog.update_attributes(params[:blog])
        wants.html do
          flash[:notice]='Blog post updated.'
          redirect_to profile_blogs_path(@p)
        end
      else
        wants.html do
          flash.now[:error]='Failed to update the blog post.'
          render :action => :edit
        end
      end
    end
  end
  
  def destroy
    @blog.destroy
    respond_to do |wants|
      wants.html do
        flash[:notice]='Blog post deleted.'
        redirect_to profile_blogs_path(@p)
      end
    end
  end

  protected
  
  def get_profile
    @profile = Profile[params[:profile_id]]
  end
  
  def setup
    @user = @profile.user
    @blogs = @profile.blogs.paginate(:page => @page, :per_page => @per_page)
    
    if params[:id]
      @blog = Blog[params[:id]]
    else
      @blog = Blog.new
    end
  end
  
  
  
  def allow_to
    super :owner, :all => true
    super :all, :only => [:index, :show]
  end
  
end
