class InvitesController < ApplicationController
  def new
    authorize!(:read, Post)
  end

  def create
    authorize!(:read, Post)
    unless params[:emails].present?
      params[:emails] = params[:invite][:email]
    end
    params[:emails].split(/,|\r\n|\n/).each do |email|
      unless User.exists?(:email => email)
        unless params[:message].present?
          params[:message] = params[:invite][:body] if params[:invite]
        end
        i = Invite.new
        i.email = email
        i.inviter_id = current_user.id
        i.body = params[:message] || nil
        i.inviter_type = "User"
        i.save
        Resque.enqueue(Invitation, 
                       email, current_user.id, params[:message] || nil)
      end
    end
    redirect_to root_url
  end


end
