class ForumPostsController < ApplicationController

  before_filter :setup

  def edit
  end

  def create
    @post = @topic.posts.build(params[:forum_post])
    @post.owner = @p

    post_response @post.save, :create
  end

  def update
    post_response @post.update_attributes(params[:forum_post]), :update
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
  
  def post_response saved, action
    respond_to do |format|
      if saved
        format.html do
          flash[:notice] = 'ForumPost was successfully saved.' 
          redirect_to(forum_topic_url(@forum, @topic)+"\##{@post.dom_id}") 
        end
        format.xml  { render :xml => @post, :status => (action == :create ? :created : :updated), :location => @post }
        format.js do
          render :update do |page|
            if action == :create
              page.insert_html :bottom, "posts_list", :partial => 'forum_posts/post', :object => @post
              page << "$('followup_post_body').value = ''"
              page.replace_html "topic_details", topic_details(@topic)
            else  
              page.replace_html @post.dom_id, :partial => 'forum_posts/post', :object => @post
              page << "$('TB_ajaxContent').innerHTML = ''" #otherwise we get double content on next show
              page << "tb_remove()"
            end
            page.visual_effect :highlight, @post.dom_id
            page << "tb_init('\##{@post.dom_id}_edit_link')"
          end
        end
      else
        format.html do 
          if action == :create
            session[:new_forum_post] = @post
            redirect_to(forum_topic_url(@forum, @topic)) 
          else
            render :action => "edit"
          end
        end
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
    super :admin, :all => true
    super :user, :only => [:new, :create]
  end
  
end