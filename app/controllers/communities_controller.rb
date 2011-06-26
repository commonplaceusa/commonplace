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
      @events = current_community.events.
        upcoming.
        includes(:owner, :replies => :user).
        first(3).to_a

      @announcements = current_community.announcements.
        includes(:owner, :replies => :user).
        first(3).to_a

      @posts = current_community.posts.
        order("created_at DESC").
        includes(:user, :replies => :user).
        first(3).to_a

      @group_posts = GroupPost.includes(:group, :user, :replies => :user).
        where(:groups  => {:community_id => current_community.id}).
        first(3).to_a

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
