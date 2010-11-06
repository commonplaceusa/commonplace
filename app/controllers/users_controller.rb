class UsersController < CommunitiesController
  load_and_authorize_resource

  def index
    @items = current_community.users
  end

  def show
  end


end
