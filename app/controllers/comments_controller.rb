class CommentsController < ApplicationController
  skip_filter :store_location, :only => [:create, :destroy]
  before_filter :setup
  
  
  def index
    @comments = Comment.between_profiles(@p, @profile).paginate(:page => @page, :per_page => @per_page)
    redirect_to @p and return if @p == @profile
    respond_to do |wants|
      wants.html {render}
      wants.rss {render :layout=>false}
    end
  end
  
  def create
    @comment = @parent.comments.new(params[:comment].merge(:profile_id => @p.id))
    
    respond_to do |wants|
      if @comment.save
        wants.js do
          render :update do |page|
            page.insert_html :top, "#{dom_id(@parent)}_comments", :partial => 'comments/comment', :object => @comment
            page.visual_effect :highlight, "comment_#{@comment.id}".to_sym
            page << 'tb_remove();'
            page << "jq('#comment_comment').val('');"
          end
        end
      else
        wants.js do
          render :update do |page|
            page << "message('Oops... I could not create that comment');"
          end
        end
      end
    end
  end
  
  protected
    
    def parent; @blog || @profile || nil; end
    
    def setup
      @profile = Profile[params[:profile_id]] if params[:profile_id]
      @user = @profile.user if @profile
      @blog = Blog.find(params[:blog_id]) unless params[:blog_id].blank?
      @parent = parent
    end
  
    def allow_to
      super :user, :only => [:index, :create]
    end

end
