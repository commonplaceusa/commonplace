class UsersOmniauthCallbacksController < Devise::OmniauthCallbacksController
  helper_method :registration
  def facebook

    if @user = User.find_for_facebook_oauth(env["omniauth.auth"])
      sign_in_and_redirect @user, :event => :authentication
    else
      @_community = Community.find(session["devise.community"])
      @registration = 
        Registration.new(User.new_from_facebook({:community_id => session["devise.community"]}, env["omniauth.auth"]))
      render "registrations/facebook_new", :layout => "registration"
    end
  end

  def passthru
    render(:file => "#{Rails.root}/public/404.html", 
           :status => 404, 
           :layout => false)
  end

  protected

  def registration 
    @registration ||= 
      Registration.new(current_user || User.new(:community => current_community))
  end
end
