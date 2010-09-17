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

    @user.transaction do
      @message = current_user.messages.build(params[:message])
      @message.save!
      @message.conversation.users << current_user << @user
      @message.conversation.save!
      @user.notifications.create(:notifiable => @message)
    end
    
  rescue
    respond_to do |format|
      format.json { render 'new' }
    end    
  else
    respond_to do |format|
      format.json
    end
  end
  
  def show
    respond_to do |format|
      format.html
      format.json
    end
  end
  
  protected
  
  def load_message
    @message = Message.find(params[:id])
  end

end
