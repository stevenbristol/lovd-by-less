class ForumTopicsController < ApplicationController
  
  helper ForumsHelper
  
  skip_filter :login_required, :only => [:show, :index]
  before_filter :setup
  
  # GET /@topics
  # GET /@topics.xml
  # def index
  #   @topics = ForumTopic.find(:all)
  # 
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render :xml => @topics }
  #   end
  # end

  # GET /@topics/1
  # GET /@topics/1.xml
  def show
    ##
    # if the validation of a followup post failed, it is stored in the session by the ForumPostsController
    if session[:new_forum_post]
      @post = session[:new_forum_post]
      session[:new_forum_post] = nil
    else
      @post = @topic.posts.new
    end
    
    @posts = @topic.posts.paginate(:all, :page => params[:page], :order => 'created_at DESC')
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /@topics/new
  # GET /@topics/new.xml
  def new
    @topic = ForumTopic.new
    @post = @topic.posts.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /@topics/1/edit
  def edit
  end

  # POST /@topics
  # POST /@topics.xml
  def create
    @topic = @forum.topics.build(params[:forum_topic])
    @topic.owner = @p
    
    @post = ForumPost.new(params[:forum_post])
    @post.owner = @p
    @topic.posts << @post
    
    logger.info "*** created topic:#{@topic.to_yaml}"
    
    respond_to do |format|
      if @topic.save
        flash[:notice] = 'ForumTopic was successfully created.'
        format.html { redirect_to(forum_topic_url(@forum, @topic)) }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /@topics/1
  # PUT /@topics/1.xml
  def update

    respond_to do |format|
      if @topic.update_attributes(params[:forum_topic])
        flash[:notice] = 'ForumTopic was successfully updated.'
        format.html { redirect_to(forum_path(@topic.forum)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /@topics/1
  # DELETE /@topics/1.xml
  def destroy
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(@forum) }
      format.xml  { head :ok }
    end
  end
  
private

  def setup
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.find(params[:id]) if params[:id]
  end

  def allow_to
    super :admin, :all => true
    super :user, :only => [:new, :create]
    super :all, :only => [:index, :show]
  end

end
