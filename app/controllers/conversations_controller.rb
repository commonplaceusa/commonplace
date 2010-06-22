class ConversationsController < ApplicationController

  def create
    @conversation = Conversation.new(params[:conversation])
    if @conversation.save
      render "show"
    else
      render "create"
    end
  end

  def update
    @conversation = Conversation.find(params[:id])
    @conversation.mark_read_for(user)
  end
    

end
