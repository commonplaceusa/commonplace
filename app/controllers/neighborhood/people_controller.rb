class Neighborhood::PeopleController < CommunitiesController
   
  def index
    authorize! :read, User
    @items = current_user.neighborhood.users
    @render_args = Proc.new { |u| ['users/user', {:user => u}] }
  end
end
