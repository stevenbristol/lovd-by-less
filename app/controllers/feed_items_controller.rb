class FeedItemsController < ApplicationController
  skip_filter :store_location
  before_filter :setup
  
  def destroy
    @profile.feeds.find(:first, :conditions => {:feed_item_id=>params[:id]}).destroy
    
    respond_to do |wants|
      wants.html do
        flash[:notice] = 'Item successfully removed from the recent activities list.'
        redirect_back_or_default @profile
      end
      wants.js { render(:update){|page| page.visual_effect :puff, "feed_item_#{params[:id]}".to_sym}}
    end
  end
  
  
  protected
  
  def allow_to
    super :user, :only => [:destroy]
  end
  
  def setup
    @profile = Profile[params[:profile_id]]
    if @p != @profile
      respond_to do |wants|
        wants.html do
          flash[:notice] = "Sorry, you can't do that."
          redirect_back_or_default @profile
        end
        wants.js { render(:update){|page| page.alert "Sorry, you can't do that."}}
      end
    end
  end
end