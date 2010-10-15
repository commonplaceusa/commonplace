class Neighborhood::PostsController < CommunitiesController 
  
  layout 'zone'

  def index
    authorize! :read, Post
    @items = current_user.neighborhood.posts.sort_by(&:created_at).reverse
  end

end
