class SiteController < ApplicationController

  def index 
    if current_user_session
      @post = Post.new
      render 'home'
    else
      render 'index'
    end
  end

  def about ; end
  
  def privacy ; end

  def terms ; end
  

end
