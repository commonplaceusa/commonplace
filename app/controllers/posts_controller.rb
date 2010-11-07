class PostsController < CommunitiesController
  helper_method :post

  load_and_authorize_resource
  
  caches_action :show

  def index
    @items = current_user.neighborhood.posts.sort_by(&:created_at).reverse
  end

  def new
  end

  def create
    @post.user = current_user
    if @post.save
      current_user.neighborhood.notifications.create(:notifiable => @post)
      flash[:message] = "Post Created!"
      redirect_to posts_path
    else
      render :new
    end
  end

  def show
  end
  
  def destroy
    if @post.destroy
      flash[:win] = "Post deleted."
    else
      flash[:fail] = "There was an error deleting your post--please try again."
    end
    redirect_to root_url
  end
  
  protected 
  def post
    @post 
  end
    
end
