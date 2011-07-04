class AccountsController < CommunitiesController

  layout 'application'

  protect_from_forgery :except => :update
  caches_action :new
  def new
    if can? :create, User
      @user = User.new
      if params[:short]
        params[:action] = "new short"
        render :short
      else
        render
      end
    else
      redirect_to root_url
    end
  end
  
  def new_from_facebook
    if can? :create, User
      @user = User.new
      @user.send_to_facebook
    else
      redirect_to root_url
    end
  end
  
  def show
    redirect_to edit_account_url
  end

  def delete
  end

  def destroy
    current_user.destroy
    redirect_to root_url
  end
  
  def create
    authorize! :create, User
    params[:user] ||= {}
    password = ""
    if params[:user][:facebook_session].present?
      j = ActiveSupport::JSON.decode(params[:user][:facebook_session])
      params[:user][:facebook_uid] = j["uid"]
      params[:user].delete("facebook_session")
    end
    if params[:user][:facebook_uid].present?
      password = params[:user][:facebook_uid]
      # Permute it!
      password = $CryptoKey.encrypt(password)
    end
    
    @user = User.new(params[:user].merge(:community => current_community))
    if @user.save
      unless password == ""
        @user.password = password
        @user.save!
      end
      Resque.enqueue(Welcome, @user.id)
      if params[:short]
        redirect_to new_feed_url
      else
        redirect_to edit_new_account_url
      end
    else
      render params[:short] ? :short : :new
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
    current_user.attributes = params[:user]
    if current_user.save
      if params[:user][:avatar].blank?
        redirect_to :action => "add_feeds"
      else
        redirect_to :action => "crop"
      end
    else
      render :edit_new
    end
  end

  def update_crop
    authorize! :update, User
    current_user.attributes = params[:user]
    if current_user.save
      redirect_to :action => "add_feeds"
    else
      render :edit_new
    end
  end

  def add_feeds
    @feeds = current_community.feeds
    if @feeds.present?
      render
    else
      redirect_to :action => "add_groups"
    end
  end
  
  def subscribe_to_feeds
    current_user.feed_ids = params[:feed_ids]
    redirect_to :action => "add_groups"
  end

  def add_groups
    @groups = current_community.groups
    if @groups.present?
      render
    else
      redirect_to root_url
    end
  end

  def subscribe_to_groups
    current_user.group_ids = params[:group_ids]
    if current_user.facebook_user? and $rollout.active(:facebook_invite, current_user)
      redirect_to :action => "facebook_invite"
    else
      redirect_to root_url
    end
  end

  def update
    current_user.update_attributes(params[:user])
    redirect_to root_url
  end
  
  def take_photo
    File.open("#{ Rails.root }/tmp/#{current_user.id}_upload.jpg", 'w') do |f|
      f.write request.raw_post
    end
    current_user.avatar = File.new("#{Rails.root}/tmp/#{current_user.id}_upload.jpg")
    current_user.save
    render :nothing => true
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

  def facebook_invite
    @invitation = Invite.new
  end

  def profile
    authorize! :update, User
  end

  private

  def single_access_allowed?
    true
  end
  
end
