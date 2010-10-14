class Neighborhood::PostsController < CommunitiesController 
  
  layout false

  def index
    authorize! :read, Post
    @posts = current_user.neighborhood.posts
  end

end
