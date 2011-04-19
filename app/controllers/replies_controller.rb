class RepliesController < CommunitiesController
  
  def create
    authorize! :create, Reply
    @reply = current_user.replies.build(params[:reply])
    if @reply.save
      (@reply.repliable.replies.map(&:user) + [@reply.repliable.user]).uniq do |user|
        Resque.enqueue(ReplyNotification, @reply.id, user.id) if user != reply.current_user
      end

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
