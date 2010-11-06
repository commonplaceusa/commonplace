class MessagesController < CommunitiesController
  helper_method :parent

  def new
    @user = parent
    @message = Message.new(:conversation => Conversation.new)
  end

  def create
    @message = parent.messages.build(params[:message])
    if @message.save
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
