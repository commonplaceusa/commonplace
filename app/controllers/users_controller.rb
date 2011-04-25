class UsersController < CommunitiesController
  load_and_authorize_resource

  def index
    @neighbors = current_community.users.sort_by(&:last_name)
  end

  def show
  end


end
