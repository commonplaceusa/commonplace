class CommunitiesController < ApplicationController
  before_filter :current_community, :current_neighborhood

  helper_method :posts, :announcements, :events

  def good_neighbor_discount
    render :layout => "application"
  end
  
  layout 'communities'
  
  def show
    if logged_in?
      render :layout => false
    else
      raise CanCan::AccessDenied
    end
  end

end
