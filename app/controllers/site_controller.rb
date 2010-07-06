class SiteController < ApplicationController
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
