class InboxesController < ApplicationController

  def show
    @inbox = current_user.inbox
  end

end
