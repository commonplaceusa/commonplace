class RepliesController < CommunitiesController
  
  def create
    authorize! :create, Reply
    @reply = current_user.replies.build(params[:reply])
    if @reply.save
      (@reply.repliable.replies.map(&:user) + [@reply.repliable.user]).uniq.each do |user|
        if user != @reply.user
          logger.info("Enqueue ReplyNotification #{@reply.id} #{user.id}")
          Resque.enqueue(ReplyNotification, @reply.id, user.id)
        end
      end

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
