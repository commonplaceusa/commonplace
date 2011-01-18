class UserSessionsController < ApplicationController
  
  def new
    authorize! :new, UserSession
    @user = User.new
  end

  def create
    authorize! :create, UserSession
    @user_session = UserSession.new(params[:user_session])
    @user_session.remember_me = true
    @user_session.save do |result|
      if result
        reload_current_user!
        redirect_back_or_default root_url
      else
        @user = User.new
        @user_session_errors = true
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
