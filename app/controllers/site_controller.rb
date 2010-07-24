class SiteController < ApplicationController

  filter_access_to :all
  layout "public"
  
  def index 
    redirect_to community_url(current_user.community.name) if current_user_session
  end

  def about ; end
  
  def privacy ; end

  def terms ; end

end
