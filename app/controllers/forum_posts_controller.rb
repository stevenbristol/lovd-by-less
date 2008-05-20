class ForumPostsController < ApplicationController

  before_filter :setup

  # GET /forum_posts/1/edit
  def edit
  end

  # POST /forum_posts
  # POST /forum_posts.xml
  def create
    @post = @topic.posts.build(params[:forum_post])
    @post.owner = @p

    respond_to do |format|
      if @post.save
        flash[:notice] = 'ForumPost was successfully created.'
        format.html { redirect_to(forum_topic_url(@forum, @topic)) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html do 
          session[:new_forum_post] = @post
          logger.info "*** could not create new post. storing in session: #{session[:new_forum_post].to_yaml}"
          redirect_to(forum_topic_url(@forum, @topic)) 
        end
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forum_posts/1
  # PUT /forum_posts/1.xml
  def update

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'ForumPost was successfully updated.'
        format.html { redirect_to(forum_topic_url(@forum, @topic)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forum_posts/1
  # DELETE /forum_posts/1.xml
  def destroy
    @post = ForumPost.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(forum_topic_url(@forum, @topic)) }
      format.xml  { head :ok }
    end
  end

private

  def setup
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.find(params[:topic_id])
    @post = @topic.posts.find(params[:id]) if params[:id]
  end

  def allow_to
    super :admin, :all => true
    super :user, :only => [:new, :create]
  end
  
  
end


# GET /forum_posts
# GET /forum_posts.xml
# def index
#     @posts = ForumPost.find(:all)
# 
#     respond_to do |format|
#       format.html # index.html.erb
#       format.xml  { render :xml => @posts }
#     end
#   end
# 
#   # GET /forum_posts/1
#   # GET /forum_posts/1.xml
#   def show
#     @post = ForumPost.find(params[:id])
# 
#     respond_to do |format|
#       format.html # show.html.erb
#       format.xml  { render :xml => @post }
#     end
#   end

# # GET /forum_posts/new
# # GET /forum_posts/new.xml
# def new
#   @post = ForumPost.new
# 
#   respond_to do |format|
#     format.html # new.html.erb
#     format.xml  { render :xml => @post }
#   end
# end