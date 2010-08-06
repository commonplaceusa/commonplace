class InvitesController < ApplicationController

  def new
    @invite = Invite.new
    respond_to do |format|
      format.json
    end
  end

  


end
