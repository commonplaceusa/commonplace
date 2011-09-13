class MessagesController < CommunitiesController
  helper_method :parent
  
  layout 'application'
    
  def index ; end
  
  def show
    @message = Message.find(params[:id])
    authorize! :show, @message
  end

  def new
    if logged_in?
      render :layout => 'communities'
    else
      redirect_to :controller => :accounts, :action => :new
    end
  end

  def create
    @message = current_user.messages.build(params[:message])
    if @message.save
      flash.now[:message] = "Message sent to #{@message.messagable.name}"
      kickoff.deliver_user_message(@message)
      render :create, :layout => false
    else
      render :new, :layout => false
    end
  end
  
  def archive
    message = Message.find(params[:id])
    authorize! :show, message
    message.archived = true
    message.save
    redirect_to :action => 'index'
  end
  
  def admin_quick_view
    # User must be an administrator
    unless current_user.admin
      redirect_to root_url
    else
      @messages = Message.find(:all, :order => "id desc", :limit => 50).sort { |x, y| y.created_at <=> x.created_at }
      render :layout => false
    end
  end
  

  protected
  def parent
    @parent ||= params[:messagable_type].singularize.camelize.constantize.find(params[:messagable_id])
  end
end
