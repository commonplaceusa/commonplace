class UsersController < CommunitiesController


  def index
    @users = User.all
  end


end
