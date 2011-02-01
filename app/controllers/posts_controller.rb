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
    @post.area = current_neighborhood
    if @post.save
      puts @post.inspect
      post_params = params[:post]
      if (post_params[:post_to_facebook] == "1")
        #current_user.access_token.post("/" + current_user.facebook_uid.to_s + "/feed/", :message => "Test")
      end
      
      NotificationsMailer.deliver_neighborhood_post(current_neighborhood.id,
                                                    post.id)
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

  def uplift
    if can?(:uplift, @post) && @post.area.is_a?(Neighborhood)
      original_neighborhood = @post.area
      @post.area = current_community
      @post.save
      current_community.neighborhoods.reject {|n| n == original_neighborhood }.
        each do |n|
        NotificationsMailer.deliver_neighborhood_post(n.id,@post.id)
      end
    end
    redirect_to root_url
  end
  
  protected 
  def post
    @post 
  end
    
end
