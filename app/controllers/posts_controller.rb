class PostsController < CommunitiesController
  helper_method :post

  load_and_authorize_resource
  
  caches_action :show
  layout 'zone'

  def index
    @items = current_user.neighborhood.posts.sort_by(&:created_at).reverse
  end

  def new
    render :layout => false
  end

  def create
    @post.user = current_user
    if @post.save
      flash[:message] = "Post Created!"
      redirect_to posts_url
    else
      render :new, :layout => false
    end
  end

  def show
    render :layout => false
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
