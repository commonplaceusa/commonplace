class UsersController < CommunitiesController
  load_and_authorize_resource

  def index
    @items = current_community.users.sort_by(&:last_name)
  end

  def show
  end


end
