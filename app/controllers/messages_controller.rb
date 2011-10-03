class MessagesController < CommunitiesController
    
  def admin_quick_view
    # User must be an administrator
    unless current_user.admin
      redirect_to root_url
    else
      @messages = Message.find(:all, :order => "id desc", :limit => 50).sort { |x, y| y.created_at <=> x.created_at }
      render :layout => false
    end
  end
  
end
