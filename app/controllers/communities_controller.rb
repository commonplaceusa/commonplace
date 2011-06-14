class CommunitiesController < ApplicationController
  before_filter :current_community
  before_filter :authorize_current_community

  helper_method :posts, :announcements, :events

  layout 'communities'
  
  def show
    if current_user_session.new_session?
      @user = User.new
      params[:controller], params[:action] = "accounts", "new"
      render 'accounts/new', :layout => 'application'
    else
      render 'show'
    end
  end



  def posts
    @posts ||= current_community.posts.all(:limit => 3)
  end
  
  def announcements
    @announcements ||= current_community.announcements.all(:limit => 3)
  end

  def events
    @events ||= current_community.events.upcoming.take(3)
  end
end
