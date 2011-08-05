class CommunitiesController < ApplicationController
  before_filter :current_community

  helper_method :posts, :announcements, :events

  layout 'communities'
  
  def show
    if logged_in?
      @events = cp_client.community_events(current_community.id)
      @announcements = cp_client.community_publicity(current_community.id)
      @posts = if (current_community.is_college) 
                 cp_client.neighborhood_posts(current_user.neighborhood_id)
               else
                 cp_client.community_posts(current_community.id)
               end
      @group_posts = cp_client.community_group_posts(current_community.id)
      @users = cp_client.community_neighbors(current_community.id)
      @feeds = cp_client.community_feeds(current_community.id)
      @groups = cp_client.community_groups(current_community.id)
      render 'show'
    else
      raise CanCan::AccessDenied
    end
  end
end
