class FlashersController < ApplicationController
  def index
    flash[:actual_flash] = params[:actual_flash]
    flash.now[:actual_flash_now] = params[:actual_flash_now]
    render :text => 'blah'
  end
end
