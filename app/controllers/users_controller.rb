class UsersController < CommunitiesController
  load_and_authorize_resource

  def index
    @neighbors = current_neighborhood.users.sort_by(&:last_name)
    @users = current_community.users.sort_by(&:last_name) - @neighbors
  end

  def show
  end


end
