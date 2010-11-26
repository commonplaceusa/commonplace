class CommunitiesController < ApplicationController
  before_filter :current_community
  before_filter :authorize_current_community

  layout :community_layout
  
  
  def show
    if current_user_session
      @posts = current_user.neighborhood.posts.sort_by(&:created_at).reverse.take(2)
      @announcements = current_community.announcements.all(:order => 'created_at DESC').take(2)
      @events = current_community.events.take(2)
    else
      @items = current_user.wire
    end
  end

  protected
  
  def community_layout
    current_user_session ? 'communities' : 'signup'
  end

end
