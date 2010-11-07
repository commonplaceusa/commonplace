class AccountsController < CommunitiesController
  
  def new
    unless can? :new, User
      redirect_to root_url
    end
    @user = User.new
  end
  
  def create
    params[:user][:privacy_policy] = params[:user][:privacy_policy].last if params[:user][:privacy_policy].is_a?(Array)
    authorize! :create, User
    @location = Location.new(params[:user].delete(:location))
    @neighborhood = current_community.neighborhoods.first
    @user = @neighborhood.users.build(params[:user])
    if @user.save
      @location.locatable = @user
      @location.save
      redirect_to edit_account_path
    else
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    authorize! :update, User
    if current_user.update_attributes(params[:user]) || true
      redirect_to new_first_post_path
    else
      render :edit
    end
  end

end
