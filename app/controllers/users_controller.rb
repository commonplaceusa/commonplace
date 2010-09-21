class UsersController < CommunitiesController
  load_and_authorize_resource
  def index
    respond_to do |format|
      if params[:q]
        @results = current_community.users.tagged_with_aliases(params[:q], :any => true)
        format.json { render :search }
        format.html { render :search }
      else
        @users = current_community.users
        format.json
        format.html
      end
    end
  end

  def show
    respond_to do |format|
      format.json
    end
  end


end
