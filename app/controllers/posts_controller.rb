class PostsController < CommunitiesController
  helper_method :post

  load_and_authorize_resource

  def index
    @items = current_neighborhood.posts.sort_by(&:created_at).reverse
  end

  def new
  end

  def create
    @post.user = current_user
    @post.neighborhood_id = current_neighborhood.id
    if @post.save
      current_neighborhood.notifications.create(:notifiable => @post)
      flash[:message] = "Post Created!"
      redirect_to posts_path
    else
      render :new
    end
  end
  
  def destroy
    if can? :destroy, @post
   # if (@post.user_may_delete(current_user))
      if @post.destroy
        flash[:message] = "Post Deleted!"
        redirect_to posts_path
      else
        render :new
      end
    end
  end

  def show
  end
  
  protected 
  def post
    @post 
  end
    
end
