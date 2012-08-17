class UsersOmniauthCallbacksController < Devise::OmniauthCallbacksController
  helper_method :registration
  def facebook

    if @user = User.find_for_facebook_oauth(env["omniauth.auth"])
      sign_in_and_redirect @user, :event => :authentication
    else
      @_community = Community.find_by_slug(cookies[:commonplace_community_slug]) if cookies[:commonplace_community_slug].present?
      @_community = Community.find(session["devise.community"]) if session["devise.community"].present?
      user = User.new_from_facebook({:community_id => @_community.id}, env["omniauth.auth"])
      user.save
      warden.set_user(user, :scope => :user)
      redirect_to "/#{@_community.slug}"
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
