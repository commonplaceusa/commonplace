class UsersController < CommunitiesController


  def index
    @users = User.all
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
