class SiteController < CommunitiesController
  
  def privacy ; end

  def terms ; end
  
  def contact 
    if !is_user_logged_in?
      # If the user is not logged in
      # Redirect to the login screen
      redirect_to :controller => "accounts", :action => "new"
    end
  end

end
