class RepliesController < CommunitiesController
  
  def create
    authorize! :create, Reply
    @reply = current_user.replies.build(params[:reply])
    if @reply.save
      kickoff.deliver_reply(@reply)

      if @reply.repliable.is_a? Message
        redirect_to message_url(@reply.repliable)
      else
        render :show, :layout => false
      end
    else
      render :new, :layout => false
    end
  end
  
end
