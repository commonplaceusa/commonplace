class UserSessionsController < ApplicationController
  filter_resource_access

  def new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
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
