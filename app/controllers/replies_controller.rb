class RepliesController < CommunitiesController
  
  def create
    authorize! :create, Reply
    @reply = current_user.replies.build(params[:reply])
    if @reply.save
      render :show
    else
      render :new
    end
  end
  
end
