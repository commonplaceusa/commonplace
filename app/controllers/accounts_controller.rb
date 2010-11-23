class AccountsController < CommunitiesController
  
  def new
    unless can? :new, User
      redirect_to root_url
    end
    @user = User.new
  end
  
  def create
    params[:user][:terms] = params[:user][:terms].last if params[:user][:terms].is_a?(Array)
    authorize! :create, User
    @location = Location.new(params[:user].delete(:location).merge(:zip_code => current_community.zip_code))
    @location.update_lat_and_lng
    @avatar = Avatar.new
    @neighborhood = current_community.neighborhoods.to_a.
      find(lambda{current_community.neighborhoods.first}) do |n|
      @location.within?(n.bounds) if n.bounds
    end
    @user = @neighborhood.users.build(params[:user].merge(:location => @location, :avatar => @avatar))
    if @user.save
      redirect_to edit_new_account_url
    else
      logger.info(@user.errors.inspect)
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
    logger.info(params[:user].inspect)
    if params[:user][:avatar]
      @avatar = current_user.avatar
      @avatar.update_attributes(params[:user][:avatar])
      logger.info(@avatar.inspect)
      params[:user].delete(:avatar)
      crop_avatar = true
    end
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

  def edit_avatar
    @avatar = current_user.avatar
  end

  def update_avatar
    @avatar = current_user.avatar
    @avatar.update_attributes(params[:avatar])
    @avatar.save
    redirect_to new_first_post_url
  end

end
