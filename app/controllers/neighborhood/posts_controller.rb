class Neighborhood::PostsController < CommunitiesController 
  
  layout 'zone'

  def index
    authorize! :read, Post
    @items = current_user.neighborhood.posts
  end

end
