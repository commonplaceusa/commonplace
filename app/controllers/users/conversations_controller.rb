class Users::ConversationsController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @conversation = Conversation.new
    respond_to do |format|
      format.json
    end
  end
end
