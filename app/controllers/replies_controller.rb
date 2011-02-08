class RepliesController < CommunitiesController
  
  def create
    authorize! :create, Reply
    @reply = current_user.replies.build(params[:reply])
    if @reply.save
      NotificationsMailer.send("deliver_#{@reply.repliable.class.name.downcase}_reply", @reply.id)
      if @reply.repliable.is_a? Message
        redirect_to messages_url
      else
        render :show
      end
    else
      render :new
    end
  end
  
end
