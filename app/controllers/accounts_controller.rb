class AccountsController < CommunitiesController

  layout 'application'
  
  def new
    if can? :create, User
      render :layout => 'application'
    else
      redirect_to root_url
    end
  end
  
  def create
    authorize! :create, User
    current_user.location = Location.new(params[:user].delete(:location_attributes).merge(:zip_code => current_community.zip_code))
    current_user.location.update_lat_and_lng
    current_user.avatar = Avatar.new
    current_user.neighborhood = current_community.neighborhoods.to_a.
      find(lambda{current_community.neighborhoods.first}) do |n|
      current_user.location.within?(n.bounds) if n.bounds
    end
    current_user.full_name = params[:user][:full_name]
    current_user.email = params[:user][:email]
    if current_user.save
      redirect_to edit_new_account_url
    else
      render :new
    end
  end

  def edit
  end

  def edit_new
  end

  def update_new
    authorize! :update, User
    if params[:user][:avatar]
      @avatar = current_user.avatar
      @avatar.update_attributes(params[:user][:avatar])
      params[:user].delete(:avatar)
      crop_avatar = true
    end
    if current_user.update_attributes(params[:user])
      redirect_to edit_interests_account_path
    else
      @user = current_user
      render :edit_new
    end
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to root_url
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

  def learn_more
  end

  def edit_interests
  end

  def update_interests
    current_user.interest_list = params[:user][:interest_list]
    current_user.save
    redirect_to root_url
  end
end
