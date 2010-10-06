class PostsController < CommunitiesController
  load_and_authorize_resource

  caches_action :show
  def index
    @posts = Post.all
  end

  def new
    respond_to do |format|
      format.json
    end
  end
  
  def create
    respond_to do |format|
      if @post.save
        format.html { redirect_to root_url }
        format.json         
      else
        format.json { render 'new' }
      end
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
    
end
