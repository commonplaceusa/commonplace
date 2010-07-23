class InboxesController < ApplicationController

  def show
    @conversations = current_user.conversations
    render "index"
  end

end
