class AccountsController < CommunitiesController

  layout 'application'

  protect_from_forgery :except => :update
  
  def new
    if can? :create, User
      @user = User.new
      render :layout => 'application'
    else
      redirect_to root_url
    end
  end
  
  def create
    authorize! :create, User
    @user = User.new(params[:user])

    position = LatLng.from_address(@user.address, 
                                   current_community.zip_code)
    if position
      @user.neighborhood = current_community.neighborhoods.to_a.
        find(lambda{current_community.neighborhoods.first}) do |n|
        position.within?(n.bounds) if n.bounds
      end
    else
      @user.neighborhood = current_community.neighborhoods.first
    end
    
    if @user.save
      redirect_to edit_new_account_url
    else
      render :new
    end
  end

  def edit
    if can? :edit, current_user
      render :layout => 'application'
    else
      redirect_to root_url
    end
  end

  def settings
    if current_user.update_attributes(params[:user])
      redirect_to root_url
    else
      render :edit
    end
  end

  def avatar
    current_user.update_attributes(params[:user])
    render :json => {"avatar_url" => current_user.avatar.url(:normal)}
  end

  def edit_new
  end

  def update_new
    authorize! :update, User
    if current_user.update_attributes(params[:user]) && current_user.password.present?
      redirect_to root_url
    else
      current_user.errors.add("password", "Please create a password")
      @user = current_user
      render :edit_new
    end
  end

  def update
    current_user.update_attributes(params[:user])
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
