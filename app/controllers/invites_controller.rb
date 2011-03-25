class InvitesController < CommunitiesController
  def new
    authorize!(:read, Post)
  end

  def create
    authorize!(:read, Post)
    params[:emails].split(/,|\r\n|\n/).each do |email|
      unless User.exists?(:email => email)
        Resque.enqueue(Invitation, 
                       email, current_user.id, params[:message] || nil)
      end
    end
    redirect_to new_post_path
  end


end
