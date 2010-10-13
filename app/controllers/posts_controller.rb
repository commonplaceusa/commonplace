class PostsController < CommunitiesController
  helper_method :post

  load_and_authorize_resource
  
  caches_action :show
  def index
    @posts = current_community.posts
  end
  
  def neighborhood
    @posts = current_user.neighborhood.posts
    render :index
  end

  def new
    respond_to do |format|
      format.json
    end
  end

  def _form
    @post = Post.new
    render :layout => false
  end
  
  def create
    @post.user = current_user
    if @post.save
      render :json => {"saved" => true}
    else
      render :json => {"saved" => false, "post" => @post.errors.as_json}
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json
    end
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
