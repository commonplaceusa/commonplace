class UsersOmniauthCallbacksController < Devise::OmniauthCallbacksController
  helper_method :registration
  def facebook

    if @user = User.find_for_facebook_oauth(env["omniauth.auth"])
      sign_in_and_redirect @user, :event => :authentication
    else
      @_community = Community.find(session["devise.community"])
      user = User.new_from_facebook({:community_id => session["devise.community"]}, env["omniauth.auth"])
      user.save
      warden.set_user(user, :scope => :user)
      render "#{@_community.slug}/facebook", :layout => "registration#base"
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
