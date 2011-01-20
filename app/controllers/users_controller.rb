class UsersController < CommunitiesController
  load_and_authorize_resource

  def index
    if params[:letter].present?
      @neighbors = current_community.users.all(:conditions => ["last_name ILIKE ?", params[:letter].slice(0,1) + "%"])
    else
      @neighbors = current_neighborhood.users.sort_by(&:last_name)
      @community_members = current_community.users.sort_by(&:last_name) - @neighbors
    end
  end

  def show
  end


end
