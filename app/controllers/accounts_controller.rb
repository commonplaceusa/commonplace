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
    @user = @neighborhood.users.build(params[:user].merge(:location => @location))
    if @user.save
      redirect_to edit_new_account_url
    else
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def edit_new
    @user = current_user
  end

  def update_new
    authorize! :update, User
    if current_user.update_attributes(params[:user])
      redirect_to new_first_post_path
    else
      render :edit
    end
  end

  def update
    
    if params[:user][:location]
      @location = current_user.location
      @location.update_attributes(params[:user][:location])
      params[:user].delete(:location)
    end
    if current_user.update_attributes(params[:user])
      redirect_to management_url
    else
      render :edit
    end
  end

end
