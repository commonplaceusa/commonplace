class MetsController < ApplicationController

  def create
    @user = User.find(params[:user_id])
    unless current_user.people.exists? @user
      current_user.people << @user
    end
    flash[:message] = "You have met #{@user.name}"
  end


  def destroy
    @user = User.find params[:user_id]
    current_user.people.delete @user
    current_user.save
    flash[:message] = "You've unsubscribed from #{ @user.name }."
    render :create
  end    
end
