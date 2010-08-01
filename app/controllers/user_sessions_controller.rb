class UserSessionsController < ApplicationController
  filter_access_to :new, :create, :destroy

  def new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      reload_current_user!
      redirect_to root_url
    else
      render :new
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to root_url
  end


end
