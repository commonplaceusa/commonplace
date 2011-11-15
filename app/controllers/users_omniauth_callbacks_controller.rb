class UsersOmniauthCallbacksController < Devise::OmniauthCallbacksController
  helper_method :registration
  def facebook

    if @user = User.find_for_facebook_oauth(env["omniauth.auth"])
      # account already exists
      sign_in_and_redirect @user, :event => :authentication
    else
      # account registration
      @user = User.new_from_facebook( {:community_id => session["devise.community"]}, env["omniauth.auth"] )
      render "registrations/new", :layout => "registration"
    end
  end

  def passthru
    render(:file => "#{Rails.root}/public/404.html", 
           :status => 404, 
           :layout => false)
  end

end
