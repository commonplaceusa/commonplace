class RepliesController < CommunitiesController
  
  def create
    authorize! :create, Reply
    @reply = current_user.replies.build(params[:reply])
    if @reply.save
      NotificationsMailer.send("deliver_#{@reply.repliable.class.name.downcase}_reply", @reply.id)
      render :show
    else
      render :new
    end
  end
  
end
