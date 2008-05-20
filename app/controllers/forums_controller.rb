##
# ForumsController
# Author: Les Freeman (lesliefreeman3@gmail.com)
# Created on: 5/16/08
# Updated on: 5/16/08
#

class ForumsController < ApplicationController
  skip_filter :login_required, :only => [:show, :index]
  
  # GET /forums
  # GET /forums.xml
  def index
    @forums = Forum.find(:all, :order => "position ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forums }
    end
  end

  # GET /forums/1
  # GET /forums/1.xml
  def show
    @forum = Forum.find(params[:id])
    @topics = @forum.topics.paginate(:all, :page => params[:page], :order => 'created_at DESC')
    # @topics = ForumTopic.paginate_by_forum_id @forum.id, :page => params[:page]

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @forum }
    end
  end

  # GET /forums/new
  # GET /forums/new.xml
  def new
    @forum = Forum.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @forum }
    end
  end

  # GET /forums/1/edit
  def edit
    @forum = Forum.find(params[:id])
  end

  # POST /forums
  # POST /forums.xml
  def create
    @forum = Forum.new(params[:forum])

    respond_to do |format|
      if @forum.save
        flash[:notice] = 'Forum was successfully created.'
        format.html { redirect_to(@forum) }
        format.xml  { render :xml => @forum, :status => :created, :location => @forum }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forums/1
  # PUT /forums/1.xml
  def update
    @forum = Forum.find(params[:id])

    respond_to do |format|
      if @forum.update_attributes(params[:forum])
        flash[:notice] = 'Forum was successfully updated.'
        format.html { redirect_to(forums_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forums/1
  # DELETE /forums/1.xml
  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy

    respond_to do |format|
      format.html { redirect_to(forums_url) }
      format.xml  { head :ok }
    end
  end
  
  def update_positions
    params[:forums_list].each_index do |i|
      forum = Forum.find(params[:forums_list][i])
      forum.position = i
      forum.save
    end
    render :nothing => true
    # @list = List.find(:all, :order => 'position')    
    #     render :layout => false, :action => :list
  end
  
private
  
  def allow_to
    super :admin, :all => true
    super :all, :only => [:index, :show]
  end
  
end
