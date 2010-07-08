class SiteController < ApplicationController

  filter_access_to :all
  layout "public"
  
  def index 
    if current_user_session
      @post = Post.new
      render 'home', :layout => "application"
    else
      render 'index'
    end
  end

  def about ; end
  
  def privacy ; end

  def terms ; end

end
