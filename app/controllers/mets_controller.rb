class MetsController < ApplicationController

  layout false

  def create
    @user = User.find(params[:user_id])
    unless current_user.people.exists? @user
      current_user.people << @user
    end
    flash.now[:message] = "You have met #{@user.name}"
    render :show
  end
    
end
