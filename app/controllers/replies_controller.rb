class RepliesController < CommunitiesController
  
  def create
    authorize! :create, Reply
    @reply = current_user.replies.build(params[:reply])
    if @reply.save
      kickoff.deliver_reply(@reply)
      redirect_to message_url(@reply.repliable)
    else
      render :new, :layout => false
    end
  end
  
end
