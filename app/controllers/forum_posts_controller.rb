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
        format.html do
          flash[:notice] = 'ForumPost was successfully created.' 
          redirect_to(forum_topic_url(@forum, @topic)+"\##{dom_id(@post)}") 
        end
        format.xml  { render :xml => @post, :status => :created, :location => @post }
        format.js do
          render :update do |page|
            page.insert_html :bottom, "posts_list", :partial => 'forum_posts/post', :object => @post
            page.visual_effect :highlight, dom_id(@post)
            page << "$('forum_post_body').value = ''"
          end
        end
      else
        format.html do 
          session[:new_forum_post] = @post
          redirect_to(forum_topic_url(@forum, @topic)) 
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

  def update
    respond_to do |format|
      if @post.update_attributes(params[:forum_post])
        format.html do
          flash[:notice] = 'ForumPost was successfully updated.'
          redirect_to(forum_topic_url(@forum, @topic)) 
        end
        format.xml  { head :ok }
        format.js do
          render :update do |page|
            page.replace_html dom_id(@post), :partial => 'forum_posts/post', :object => @post
            page << "tb_init('\##{dom_id(@post)}_edit_link')"
            page << "tb_remove()"
            page << "$('TB_ajaxContent').innerHTML = ''" #otherwise we get double content on next show
            page.visual_effect :highlight, dom_id(@post)
          end
        end
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
      format.js do
        if @post.frozen?
          render :update do |page|
            page.visual_effect :puff, dom_id(@post)
          end
        end
      end
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