class Management::EmailInvitesController < ApplicationController
  
  def new
    @invite = Invite.new(params[:invite])
  end

  def create
    @invite = Invite.new(params[:invite])
    respond_to do |format|
      if @invite.save
        format.json
      else
        format.json { render :new }
      end
    end
  end
end
