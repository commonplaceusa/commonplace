class InboxesController < ApplicationController

  
  def show
    @conversations = current_user.conversations
  end

end
