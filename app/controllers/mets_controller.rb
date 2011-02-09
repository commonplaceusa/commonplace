class MetsController < ApplicationController

  def create
    @user = User.find(params[:user_id])
    unless current_user.people.exists? @user
      current_user.people << @user
    end
    flash[:message] = "You have met #{@user.name}"
  end
    
end
