class MessagesController < CommunitiesController
  helper_method :parent

  def new
    @user = parent
    @message = Message.new
  end

  def create
    @message = parent.messages.build(params[:message].merge(:user => current_user))
    if @message.save
      parent.notifications.create(:notifiable => @message)
      flash.now[:message] = "Message sent to #{parent.name}"
    else
      render :new
    end
  end

  protected
  def parent
    @parent ||= params[:messagable].constantize.find(params[(params[:messagable].downcase + "_id").intern])
  end
end
