class MessagesController < CommunitiesController
  helper_method :parent
  

  def new
    authorize! :create, Reply
    @user = parent
    @message = Message.new
  end

  def create
    NotificationsMailer.send("deliver_#{parent.class.name.downcase}_message",
                             parent.id, current_user.id,
                             params[:message][:subject], params[:message][:body])
    flash.now[:message] = "Message sent to #{parent.name}"
  end
  

  protected
  def parent
    @parent ||= params[:messagable].constantize.find(params[(params[:messagable].downcase + "_id").intern])
  end
end
