class CommunitiesController < ApplicationController
  before_filter :current_community
  before_filter :authorize_current_community

  
  def show
    @items = current_user.wire
    if current_user_session
      render :layout => 'communities'
    else
      render :layout => 'signup'
    end
  end

end
