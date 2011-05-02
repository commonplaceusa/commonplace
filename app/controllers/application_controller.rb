class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  include FeedsHelper
  helper_method :current_community
  helper_method :current_neighborhood
  helper_method 'logged_in?'
  helper_method 'xhr?'
  helper_method :current_user_session, :current_user, :facebook_session

  before_filter :set_process_name_from_request
  after_filter :unset_process_name_from_request

  rescue_from CanCan::AccessDenied do |exception|
    store_location
    redirect_to root_url
  end

  protected

  def set_process_name_from_request
    $0 = request.path[0,16] 
  end   
  
  def unset_process_name_from_request
    $0 = request.path[0,15] + "*"
  end  
  
  def translate_with(options = {})
    @default_translate_options ||= {}
    @default_translate_options.merge!(options)
  end

  def set_template_format
    if xhr?
      response.template.template_format = :json
    end
  end

  def current_community
    @current_community ||= Community.find_by_slug(request.subdomain)
    translate_with :community => @current_community.name
    @current_community
  end

  def current_neighborhood
    @current_neighborhood ||= 
      (current_user.admin? && session[:neighborhood_id]) ? Neighborhood.find(session[:neighborhood_id]) :
      current_user.neighborhood
  end

  def authorize_current_community
    if @current_community
      authorize! :read, @current_community
    else
      raise CanCan::AccessDenied
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def logged_in?
    ! current_user.new_record?
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find || UserSession.new(params[:user_session])
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user || User.new(:neighborhood_id => 1)
  end

  def reload_current_user!
    @current_user_session = UserSession.find
    @current_user = current_user_session.user
  end

  def xhr?
    request.env['HTTP_X_REQUESTED_WITH'].present? || params[:xhr]
  end

  def redirect_to(options = {}, response_status = {})
    if xhr? 
      render :json => {"redirect_to" => options}
    else
      super(options, response_status)
    end
  end

end
