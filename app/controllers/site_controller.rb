class SiteController < ApplicationController

  def index 
    if current_user_session
      render 'index'
    else
      render 'home'
    end
  end

  def about ; end
  
  def privacy ; end

  def terms ; end
  

end
