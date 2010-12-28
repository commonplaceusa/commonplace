class UserSessionsController < ApplicationController
  
  def new
    authorize! :new, UserSession
    @user = User.new
  end

  def create
    authorize! :create, UserSession
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      reload_current_user!
    end
    redirect_back_or_default root_url
  end

  def destroy
    authorize! :destroy, UserSession
    current_user_session.destroy
    redirect_to root_url
  end


end
