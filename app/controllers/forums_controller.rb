##
# ForumsController
# Author: Les Freeman (lesliefreeman3@gmail.com)
# Created on: 5/16/08
# Updated on: 6/4/08
#

class ForumsController < ApplicationController
  skip_filter :login_required, :only => [:show, :index]
  before_filter :setup

  def index
    @forums = Forum.find(:all, :order => "position ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forums }
    end
  end

  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @forum }
    end
  end

  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @forum }
    end
  end

  def edit
  end

  def create
    @forum = Forum.new(params[:forum])

    respond_to do |format|
      if @forum.save
        flash[:notice] = 'Forum was successfully created.'
        format.html { redirect_to(@forum) }
        format.xml  { render :xml => @forum, :status => :created, :location => @forum }
        format.js do
          render :update do |page|
            page.insert_html :bottom, :forums_list, :partial => 'forum', :object => @forum
            page << "jq('#forum_name, #forum_description').val('');"
            page << "tb_remove()"
            page.visual_effect :highlight, dom_id(@forum)
          end
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forum.errors, :status => :unprocessable_entity }
        format.js do
          render :update do |page|
            page.alert @forum.errors.to_s
          end
        end
      end
    end
  end

  def update

    respond_to do |format|
      if @forum.update_attributes(params[:forum])
        format.html do 
          flash[:notice] = 'Forum was successfully updated.'
          redirect_to(forums_path) 
        end
        format.xml  { head :ok }
        format.js do
          render :update do |page|
            page.replace_html dom_id(@forum), :partial => 'forum', :object => @forum
            page << "tb_init('\##{dom_id(@forum)}_edit_link')"
            page << "tb_remove()"
            page << "$('TB_ajaxContent').innerHTML = ''" #otherwise we get double content on next show
            page.visual_effect :highlight, dom_id(@forum)
          end
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forum.errors, :status => :unprocessable_entity }
        format.js do
          render :update do |page|
            page.alert @forum.errors.to_s
          end
        end
      end
    end
  end

  def destroy
    @forum.destroy

    respond_to do |format|
      format.html { redirect_to(forums_url) }
      format.xml  { head :ok }
      format.js do
        if @forum.frozen?
          render :update do |page|
            page.visual_effect :puff, dom_id(@forum)
          end
        end
      end
    end
  end
  
  def update_positions
    params[:forums_list].each_index do |i|
      forum = Forum.find(params[:forums_list][i])
      forum.position = i
      forum.save
    end
    render :nothing => true
  end
  
private
  
  def setup
    if params[:id]
      @forum = Forum.find(params[:id], :include => :topics, :order => "forum_topics.updated_at DESC")
      @topics = @forum.topics.paginate(:all, :page => params[:page])
      @topic = @forum.topics.new
      @post = ForumPost.new
    else
      @forum = Forum.new
    end
  end
  
  def allow_to
    super :admin, :all => true
    super :all, :only => [:index, :show]
  end
  
end
