class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  helper_method :current_community
  helper_method 'logged_in?'

  
  before_filter :domain_redirect

  def kickoff
    @kickoff ||= KickOff.new
  end

  def after_sign_out_path_for(resource_or_scope)
    community_slug = cookies[:commonplace_community_slug]
    if community_slug.present?
      return "/#{community_slug}"
    elsif request.referrer.present?
      return request.referrer
    else
      return "/login"
    end
  end

  protected

  def translate_with(options = {})
    @default_translate_options ||= {}
    @default_translate_options.merge!(options)
  end

  def domain_redirect
    return unless Rails.env.production?
    return if request.host == "commonplace.herokuapp.com"
    case request.host

    when %r{^www\.ourcommonplace\.com$}
      return

    when %r{^assets\.}
      return

    when %r{^ourcommonplace\.com$}
      redirect_to "https://www.ourcommonplace.com#{request.fullpath}", :status => 301
      return

    when %r{^(?:www\.)?([a-zA-Z]+)\.ourcommonplace\.com$}
      if request.path == "/" || request.path == ""
        redirect_to "https://www.ourcommonplace.com/#{$1}", :status => 301
      else
        redirect_to "https://www.ourcommonplace.com#{request.fullpath}", :status => 301
      end

    when %r{^(?:www\.)?commonplaceusa.com$}
      case request.path
      when %r{^/$}
        redirect_to "https://www.ourcommonplace.com/about", :status => 301
      else
        redirect_to "https://www.ourcommonplace.com#{request.fullpath}", :status => 301
      end
    end
    
  end

  def current_community
    @_community ||= if params[:community]
                      Community.find_by_slug(params[:community])
                    elsif logged_in?
                      current_user.community
                    else
                      nil
                    end
    
    if @_community
      params[:community] = @_community.slug
      translate_with :community => @_community.name
      Time.zone = @_community.time_zone
      cookies[:commonplace_community_slug] = @_community.slug
    end

    @_community
  end
  

  def logged_in?
    user_signed_in?
  end

end
