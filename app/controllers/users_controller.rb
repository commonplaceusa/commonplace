class UsersController < CommunitiesController

  def index
    respond_to do |format|
      if params[:q]
        @results = current_community.users.tagged_with_aliases(params[:q], :any => true)
        format.json { render :search }
        format.html { render :search }
      else
        @neighbors = []
        @community_users = current_community.users.all(:conditions => ["users.id NOT IN (?)", @neighbors + [0]])
        
        format.json
        format.html
      end
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.json
    end
  end


end
