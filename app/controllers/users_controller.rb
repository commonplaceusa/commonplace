class UsersController < CommunitiesController
  load_and_authorize_resource
  def index
    @users = current_community.users
  end

  def show
    respond_to do |format|
      format.json
    end
  end


end
