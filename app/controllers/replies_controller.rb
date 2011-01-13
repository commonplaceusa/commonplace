class RepliesController < CommunitiesController
  
  def create
    authorize! :create, Reply
    @reply = current_user.replies.build(params[:reply])
    if @reply.save
      @reply.repliable.notifications.create(:notifiable => @reply) if @reply.repliable.is_a?(Post)
      render :show
    else
      render :new
    end
  end
  
end
