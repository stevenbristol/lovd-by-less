class MessagesController < ApplicationController
  before_filter :can_send, :only => :create
  
  
  def index
    @message = Message.new
    @to_list = @p.friends
    
    if @p.received_messages.empty? && @p.has_network?
      flash[:notice] = 'You have no mail in your inbox.  Try sending a message to someone.'
      @to_list = (@p.followers + @p.friends + @p.followings)
      redirect_to new_profile_message_path(@p) and return
    end
  end
  
  def create
    @message = @p.sent_messages.create(params[:message]) 
    
    respond_to do |wants|
      if @message.new_record?
        wants.js do
          render :update do |page|
            page.alert @message.errors.to_s
          end
        end
      else
        wants.js do
          render :update do |page|
            page.alert "Message sent."
            page << "jq('#message_subject, #message_body').val('');"
            page << "tb_remove()"
          end
        end
      end
    end
  end
  
  def new
    @message = Message.new
    @to_list = (@p.followers + @p.friends + @p.followings)
    render
  end
  
  
  def sent
    @message = Message.new
    @to_list = @p.friends
  end
  
  def show
    @message = @p.sent_messages.find params[:id] rescue nil
    @message ||= @p.received_messages.find params[:id] rescue nil
		if not @message.nil?
			@message.read = true
			@message.save
		end
    @to_list = [@message.sender]
  end
  


  protected
  def allow_to
    super :user, :all => true
  end
  
  def can_send
    render :update do |page|
      page.alert "Sorry, you can't send messages. (Cuz you sux.)"
    end unless @p.can_send_messages
  end
end
