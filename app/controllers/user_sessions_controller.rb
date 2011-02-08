class UserSessionsController < ApplicationController
  
  def new
    authorize! :new, UserSession
    @user = User.new
  end

  def create
    authorize! :create, UserSession
    current_user_session.remember_me = true
    current_user_session.save do |result|
      if result
        reload_current_user!
        redirect_back_or_default root_url
      else
        @user = User.new
        params[:controller] = "accounts"
        params[:action] = "new"
        render 'accounts/new'
      end
    end
  end

  def show
    redirect_to root_url
  end

  def destroy
    authorize! :destroy, UserSession
    current_user_session.destroy
    redirect_to root_url
  end


end
