class ActionController::Base
  helper :less_authentication
  helper_method 'logged_in?'

  def logged_in?
    return nil if session[:user].nil?
    return @u unless @u.nil?
    self.user = User.find_by_id(session[:user])
  end
  
  # Accesses the current user from the session.
  def user
    @u if logged_in?
  end
  
  # Store the given user in the session.
  def user=(u)
    return if u.nil? or !u.respond_to?(:new_record?)
    session[:user] = u.id unless u.new_record?
    @u = u
  end
  
  # Check if the user is authorized.
  #
  # Override this method in your controllers if you want to restrict access
  # to only a few actions or if you want to check if the user
  # has the correct rights.
  #
  # Example:
  #
  #  # only allow nonbobs
  #  def authorize?
  #    user.login != "bob"
  #  end
  def authorized?
    true
  end
  
  
  def check_user
    @u = session[:user] ? user : nil
  end

  # Filter method to enforce a login requirement.
  #
  # To require logins for all actions, use this in your controllers:
  #
  #   before_filter :login_required
  #
  # To require logins for specific actions, use this in your controllers:
  #
  #   before_filter :login_required, :only => [ :edit, :update ]
  #
  # To skip this in a subclassed controller:
  #
  #   skip_before_filter :login_required
  #
  def login_required
    return true if @u
    username, passwd = get_auth_data
    self.user ||= User.authenticate(username, passwd) || :false if username && passwd
    logged_in? && authorized? ? true : access_denied
  end
  
  # Redirect as appropriate when an access request fails.
  #
  # The default action is to redirect to the login screen.
  #
  # Override this method in your controllers if you want to have special
  # behavior in case the user is not authorized
  # to access the requested action.  For example, a popup window might
  # simply close itself.
  def access_denied
    store_location
    redirect_to login_url
  end  
  
  # Store the URI of the current request in the session.
  #
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    return true if request.xhr?
    session[:return_to] = "#{request.request_uri}"
  end



    
    
    
  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.
  def redirect_back url
    redirect_back_or_default url
  end
  def redirect_back_or_default(default)
    return if performed?
    if session[:return_to] && 
      session[:return_to] != home_url && 
      session[:return_to] != "#{request.request_uri}" &&
      !session[:return_to].include?( request.path)
      redirect_to(session[:return_to]) 
    else 
      redirect_to(default)
    end
    session[:return_to] = nil
  end





  # Inclusion hook to make #user and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :user, :logged_in?
  end







  # When called with before_filter :login_from_cookie will check for an :auth_token
  # cookie and log the user back in if apropriate
  def login_from_cookie
    return true unless cookies[:auth_token] && !logged_in?
    return true if @u
    user = User.find_by_remember_token(cookies[:auth_token])
    if user && user.remember_token?
      user.remember_me
      self.user = user
      cookies[:auth_token] = { :value => self.user.remember_token , :expires => self.user.remember_token_expires_at  }
      flash[:notice] = "Logged in successfully"
    end
    true
  end

private

  # gets BASIC auth info
  def get_auth_data
    user, pass = nil, nil
    # extract authorisation credentials 
    if request.env.has_key? 'X-HTTP_AUTHORIZATION' 
      # try to get it where mod_rewrite might have put it 
      authdata = request.env['X-HTTP_AUTHORIZATION'].to_s.split 
    elsif request.env.has_key? 'HTTP_AUTHORIZATION' 
      # this is the regular location 
      authdata = request.env['HTTP_AUTHORIZATION'].to_s.split  
    end 
     
    # at the moment we only support basic authentication 
    if authdata && authdata[0] == 'Basic' 
      user, pass = Base64.decode64(authdata[1]).split(':')[0..1] 
    end 
    return [user, pass] 
  end
end

module ActionController #:nodoc:
  module LessAuthentication #:nodoc:
    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end
    module ClassMethods #:nodoc:
      def less_authentication(options = {})
        class_eval do
          before_filter(options) do |c|
            # c.login_from_cookie
            # c.login_required
          end
          after_filter(options) do |c|
            # c.store_location
          end
        end
      end
    end
  end
end

ActionController::Base.send :include, ActionController::LessAuthentication
