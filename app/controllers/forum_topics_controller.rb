class ForumTopicsController < ApplicationController
  
  helper ForumsHelper
  
  skip_filter :login_required, :only => [:show, :index]
  before_filter :setup
  
  def index
    redirect_to forum_path(@forum)
  end
  
  def show
    @posts = @topic.posts.paginate(:all, :page => params[:page], :order => 'created_at DESC', :per_page => @per_page)
    get_response
  end

  def new
    get_response
  end

  def edit
  end

  def create
    @topic = @forum.build_topic(params[:forum_topic].merge({:owner => @p}))
    post_response @topic.save
  end

  def update
    post_response @topic.update_attributes(params[:forum_topic])
  end

  def destroy
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(@forum) }
      format.xml  { head :ok }
      format.js do
        render :update do |page|
          page.visual_effect :puff, @topic.dom_id
          page.show "no_topics_message" if @forum.topics.count == 0
          page.replace_html "forum_details", forum_details(@forum)
        end
      end
    end
  end
  
private

  def setup
    @forum = Forum.find(params[:forum_id])
    @topic = params[:id] ? @forum.topics.find(params[:id]) : @forum.topics.build
  end
  
  def post_response saved
    respond_to do |format|
      if saved
        format.html do 
          flash[:notice] = 'ForumTopic was successfully saved.'
          redirect_to(action_name == 'create' ? forum_topic_url(@forum, @topic) : (forum_path(@topic.forum))) 
        end
        
        format.xml  { render :xml => @topic}
        
        format.js do
          render :update do |page|
            if @controller.action_name == 'create'
              page.insert_html :after, "topic_labels_row", :partial => 'forum_topics/topic', :object => @topic
              page.visual_effect :fade, "no_topics_message"
              page.replace_html "forum_details", forum_details(@forum)
              page << "$$('#new_forum_topic input[type=\"text\"]', '#new_forum_topic textarea').each(function(input){input.value=''});"
            else
              page.replace @topic.dom_id, :partial => 'forum_topics/topic', :object => @topic
              page << "$('TB_ajaxContent').innerHTML = ''" #otherwise we get double content on next show
            end
            page << "tb_init('\##{@topic.dom_id}_edit_link')"
            page << "tb_remove()"
            page.visual_effect :highlight, @topic.dom_id
          end
        end
        
      else
        format.html { render :action => (action_name == 'create' ? "new" : "edit") }
        
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
        
        format.js do
          render :update do |page|
            page.alert @topic.errors.to_s
          end
        end
        
      end
    end
  end
  
  def get_response
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  def allow_to
    super :admin, :all => true
    super :user, :only => [:new, :create]
    super :all, :only => [:index, :show]
  end

end
