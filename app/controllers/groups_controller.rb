class GroupsController < CommunitiesController
  def index
    @groups = current_community.groups
  end

  def show
    @group = Group.find(params[:id])
  end
  
end
