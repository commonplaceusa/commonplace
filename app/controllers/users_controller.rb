class UsersController < CommunitiesController
  load_and_authorize_resource

  layout 'zone'

  def index
    @items = current_community.users
  end

  def show
    respond_to do |format|
      format.json
    end
  end


end
