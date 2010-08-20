class UsersController < CommunitiesController

  def index
    @neighbors = []
    @community_users = current_community.users.all(:conditions => ["users.id NOT IN (?)", @neighbors + [0]])
    respond_to do |format|
      format.json
      format.html
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.json
    end
  end


end
