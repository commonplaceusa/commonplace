class CommunitiesController < ApplicationController
  before_filter :current_community
  before_filter :authorize_current_community

  
  def show
    @items = current_user.wire
    render :layout => params[:partial] ? 'zone' : 'communities'
  end

end
