##
# ForumPostsController
# Author: Les Freeman (lesliefreeman3@gmail.com)
# Created on: 5/16/08
# Updated on: 6/4/08
#

class ForumPostsController < ApplicationController

  before_filter :setup

  def edit
  end

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
    if params[:id]
      @post = @topic.posts.find(params[:id])
    else
      @post = ForumPost.new
    end
  end

  def allow_to
    super :admin, :all => true
    super :user, :only => [:new, :create]
  end
  
end