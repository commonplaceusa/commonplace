class MessagesController < CommunitiesController
  helper_method :parent
  

  def new
    authorize! :create, Reply
    @message = Message.new(:messagable => parent)
  end

  def create
    @message = current_user.messages.build(params[:message])
    if @message.save
      flash.now[:message] = "Message sent to #{@message.messagable.name}"
      NotificationsMailer.deliver_message(@message.id)
    else
      render :new
    end
  end
  
  def admin_quick_view
    # User must be an administrator
    unless current_user.admin
      redirect_to root_url
    else
      @messages = Message.find(:all).sort { |x, y| y.created_at <=> x.created_at }
      render :layout => false
    end
  end
  

  protected
  def parent
    @parent ||= params[:messagable].constantize.find(params[(params[:messagable].downcase + "_id").intern])
  end
end
