class GroupsController < CommunitiesController
  def index
    @groups = current_community.groups
  end

end
