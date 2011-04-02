class GroupPostsControllerController < ApplicationController
  
  load_and_authorize_resource
  
  def new
    
  end
  
  def create
    @group_post.user = current_user
    @group_post.group = params[:group_post]
    if @group_post.save
      #NotificationsMailer.deliver_neighborhood_post(current_neighborhood.id,
      #                                              post.id)
      flash[:message] = "Post Created!"
      redirect_to posts_path
    else
      render :new
    end
  end
  
  def index
    @items = current_community.groups.map(&:posts).flatten
  end
  
end
