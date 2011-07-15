class CommunitiesController < ApplicationController
  before_filter :current_community

  helper_method :posts, :announcements, :events

  layout 'communities'
  
  def show
    if logged_in?
      @events = cp_client.community_events(current_community.id)
      @announcements = cp_client.community_publicity(current_community.id)
      @posts = cp_client.community_posts(current_community.id)
      @group_posts = cp_client.community_group_posts(current_community.id)
      @users = cp_client.community_neighbors(current_community.id)
      @feeds = cp_client.community_feeds(current_community.id)
      @groups = cp_client.community_groups(current_community.id)
      render 'show'
    else
      @user = User.new
      params[:controller], params[:action] = "accounts", "new"
      render 'accounts/new', :layout => 'application'
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
