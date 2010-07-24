class SiteController < ApplicationController

  filter_access_to :all
  layout "public"
  
  def index 
    redirect_to current_user.community if current_user_session
  end

  def about ; end
  
  def privacy ; end

  def terms ; end

end
