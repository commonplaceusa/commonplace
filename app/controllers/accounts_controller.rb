class AccountsController < CommunitiesController

  layout 'application'

  protect_from_forgery :except => :update
  
  def new
    if can? :create, User
      @user = User.new
      if params[:short]
        params[:action] = "new short"
        render :short, :layout => 'application'
      else
        render :layout => 'application'
      end
    else
      redirect_to root_url
    end
  end

  
  def create
    authorize! :create, User
    params[:user] ||= {}
    @user = User.new(params[:user].merge(:community => current_community))
    
    @user.save do |result|
      if result
        if params[:short]
          redirect_to new_feed_url
        else
          redirect_to edit_new_account_url
        end
      else
        render params[:short] ? :short : :new
      end
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
    render :nothing => true
  end

  def edit_new
  end

  def update_new
    authorize! :update, User
    if current_user.facebook_uid.present?
      current_user.password = "FACEBOOK_OVERRIDE"
    end
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
