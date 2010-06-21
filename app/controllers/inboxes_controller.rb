class InboxesController < ApplicationController
  filter_resource_access

  def show
    @conversations = current_user.conversations
    render "index"
  end

end
