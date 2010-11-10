class Users::MessagesController < ApplicationController

  before_filter :load_message
  
  def new
    @user = User.find(params[:user_id])
    @message = Message.new
    respond_to do |format|
      format.json
    end
  end

  def create
    @user = User.find(params[:user_id])
    @message
    if @me
  rescue
    respond_to do |format|
      format.json { render 'new' }
    end    
  else
    respond_to do |format|
      format.json
    end
  end
  
end
