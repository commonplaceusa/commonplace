class ConversationsController < ApplicationController

  def create
    @conversation = Conversation.new(params[:conversation])
    users = User.find(@params[:conversation][:to].split(",").map(&:to_i))

    if @conversation.save
      ConversationMembership.create(:user => current_user, :conversation => @conversation)
      users.each do |user|
        user.conversation_memberships.create(:conversation => @conversation)
      end
      message = @conversation.messages.build(:body => params[:conversation][:body], 
                                             :user => current_user)
      @message.save
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
