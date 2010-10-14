class Neighborhood::PeopleController < CommunitiesController
  
  layout false
  
  def index
    authorize! :read, User
    @users = current_user.neighborhood.users
  end
end
