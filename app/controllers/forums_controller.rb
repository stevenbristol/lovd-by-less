class ForumsController < ApplicationController
  skip_filter :login_required, :only => [:show, :index]
  before_filter :setup

  def index
    @forums = Forum.find(:all, :order => "position ASC")
    get_response :xml_object => @forums
  end

  def show
    get_response
  end

  def new
    get_response
  end

  def edit
  end

  def create
    @forum = Forum.new(params[:forum])
    post_response @forum.save
  end

  def update
    post_response @forum.update_attributes(params[:forum])
  end

  def destroy
    @forum.destroy

    respond_to do |format|
      format.html { redirect_to(forums_url) }
      format.xml  { head :ok }
      format.js do
        render :update do |page|
          page.visual_effect :puff, @forum.dom_id
          page.visual_effect :appear, "no_forums_message" if Forum.count == 0
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
      @forum = Forum.find(params[:id], :include => :topics, :order => "forum_topics.created_at DESC")
      @topics = @forum.topics.paginate(:all, :page => params[:page], :per_page => @per_page)
      @topic = @forum.topics.new
    else
      @forum = Forum.new
    end
  end
  
  def get_response options = {}
    options[:xml_object] ||= @forum
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => options[:xml_object] }
    end
  end
  
  def post_response saved
    respond_to do |format|
      if saved
        format.html do 
          flash[:notice] = 'Forum was successfully saved.'
          redirect_to(forums_path) 
        end
        
        format.xml  { render :xml => @forum, :location => @forum }
        
        format.js do
          render :update do |page|
            if @controller.action_name == 'create'
              page.insert_html :bottom, :forums_list, :partial => 'forum', :object => @forum
              page.visual_effect :fade, "no_forums_message"
              page << "$$('#new_forum input[type=\"text\"]', '#new_forum textarea').each(function(input){input.value=''});"
            else
              page.replace_html @forum.dom_id, :partial => 'forum', :object => @forum
              page << "$('TB_ajaxContent').innerHTML = ''" #otherwise we get double content on next show
            end
            page << "tb_init('\##{@forum.dom_id}_edit_link')"
            page << "tb_remove()"
            page.visual_effect :highlight, @forum.dom_id
          end
        end
        
      else
        format.html { render :action => action_name == 'create' ? "new" : "edit" }
        
        format.xml  { render :xml => @forum.errors, :status => :unprocessable_entity }
        
        format.js do
          render :update do |page|
            page.alert @forum.errors.to_s
          end
        end
      end
    end
  end
  
  def allow_to
    super :admin, :all => true
    super :all, :only => [:index, :show]
  end
  
end
