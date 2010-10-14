class UsersController < CommunitiesController
  load_and_authorize_resource

  layout false
  def index
    @users = current_community.users
  end

  def show
    respond_to do |format|
      format.json
    end
  end


end
