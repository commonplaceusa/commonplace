class InvitesController < CommunitiesController
  def new
    authorize!(:read, Post)
  end

  def create
    authorize!(:read, Post)
    params[:emails].split(/,|\r\n|\n/).each do |email|
      unless User.exists?(:email => email)
        Invite.create(:email => email, :inviter => current_user, :body => params[:message])
        # TODO: Get pretty Invites
        # InviteMailer.deliver_user_invite(current_user.id,email,params[:message])
      end
    end
    redirect_to new_post_path
  end


end
