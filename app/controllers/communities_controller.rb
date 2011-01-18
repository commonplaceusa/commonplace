class CommunitiesController < ApplicationController
  before_filter :current_community
  before_filter :authorize_current_community

  helper_method :posts, :announcements, :events

  layout 'communities'
  
  def show
    if current_user_session
     
    else
      redirect_to new_account_url
    end
  end



  def posts
    @posts ||= current_neighborhood.posts.sort_by(&:created_at).reverse.take(3)
  end
  
  def announcements
    @announcements ||= current_community.announcements.all(:order => 'created_at DESC').take(3)
  end

  def events
    @events ||= current_community.events.take(3)
  end
end
