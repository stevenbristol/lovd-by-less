class ForumPostsController < ApplicationController

  before_filter :setup
  skip_filter :login_required, :only => [:show, :index]  
  
  def index
    redirect_to forum_path(@forum)
  end
  def show
    redirect_to forum_path(@forum)
  end

  def edit
  end

  def create
    @post = @topic.posts.build(params[:forum_post])
    @post.owner = @p

    post_response @post.save
  end

  def update
    post_response @post.update_attributes(params[:forum_post])
  end

  def destroy
    @post = ForumPost.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(forum_topic_url(@forum, @topic)) }
      format.xml  { head :ok }
      format.js do
        render :update do |page|
          page.visual_effect :puff, @post.dom_id
          page.replace_html "topic_details", topic_details(@topic)
        end
      end
    end
  end

private

  def setup
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.find(params[:topic_id])
    @post = params[:id] ? @topic.posts.find(params[:id]) : ForumPost.new
  end
  
  def post_response saved
    respond_to do |format|
      if saved
        format.html do
          flash[:notice] = 'ForumPost was successfully saved.' 
          redirect_to(forum_topic_url(@forum, @topic)+"\##{@post.dom_id}") 
        end
        format.xml  { render :xml => @post }
        format.js do
          render :update do |page|
            if @controller.action_name == 'create'
              page.insert_html :top, "posts_list", :partial => 'forum_posts/post', :object => @post
              page << "jq('.followup_post_body').val('');"
              page.replace_html "topic_details", topic_details(@topic)
            else  
              page.replace_html @post.dom_id, :partial => 'forum_posts/post', :object => @post
              page << "jq('#TB_ajaxContent').html(''); tb_remove();"
            end
            page.visual_effect :highlight, @post.dom_id
            page << "tb_init('\##{@post.dom_id}_edit_link')"
          end
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
        format.js do
          render :update do |page|
            page.alert @post.errors.to_s
          end
        end
      end
    end
  end

  def allow_to
    super :all, :only => [:index, :show]
    super :admin, :all => true
    super :user, :only => [:new, :create]
  end
  
end
