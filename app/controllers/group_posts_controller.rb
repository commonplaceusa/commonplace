class GroupPostsController < CommunitiesController
  helper_method :group_post
  load_and_authorize_resource
  
  def new
    
  end
  
  def create
    @group_post.user = current_user
    if @group_post.save
      redirect_to group_posts_path
    else
      render :new
    end
  end
  
  def index
    @items = current_community.groups.map(&:group_posts).flatten
  end

  def edit ; end

  def update
    if group_post.update_attributes(params[:group_post])
      redirect_to group_post_url(group_post)
    else
      render :edit
    end
  end
  
  def destroy
    if can? :destroy, group_post
      if group_post.destroy
        flash[:message] = "Post Deleted!"
        redirect_to group_posts_path
      else
        render :new
      end
    end
  end

  protected 
  def group_post
    @group_post 
  end
  
end
