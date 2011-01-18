class UserSessionsController < ApplicationController
  
  def new
    authorize! :new, UserSession
    @user = User.new
  end
  
  def create_from_facebook
    authorize! :create, UserSession
    if facebook_session
      puts facebook_session
      @user = User.find_by_facebook_uid(facebook_session.user.id)
      puts @user.inspect
      @user_session = UserSession.new(@user)
      if @user_session.save
        reload_current_user!
        redirect_back_or_default root_url
      else
        @user = User.new
        @user_session_errors = true
        params[:controller] = "accounts"
        params[:action] = "new"
        render 'accounts/new'
      end
    else  
      @user = User.new
      @user_session_errors = true
      params[:controller] = "accounts"
      params[:action] = "new"
      render 'accounts/new'
      puts "No session"
    end
  end

  def create
    authorize! :create, UserSession
    @user_session = UserSession.new(params[:user_session])
    @user_session.remember_me = true
    if @user_session.save
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

  def show
    redirect_to root_url
  end

  def destroy
    authorize! :destroy, UserSession
    current_user_session.destroy
    redirect_to root_url
  end


end
