# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
 
  protected
  
  
  def current_community
    @current_community = Community.find_by_slug(current_subdomain)
  end

  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user || User.new
  end

  def reload_current_user!
    @current_user_session = UserSession.find
    @current_user = current_user_session.user
  end
  
  def require_user
    unless current_user_session
      store_location
      flash[:message] = "You must log in to access this page."
      redirect_to login_url
      return false
    end
  end

end
