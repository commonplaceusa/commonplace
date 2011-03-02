class AccountsController < CommunitiesController

  layout 'application'

  protect_from_forgery :except => :update
  
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

  def add_feeds
    @feeds = current_community.feeds
  end

  def update_new
    authorize! :update, User
    current_user.attributes = params[:user]
    current_user.save do |result|
      if result
        if current_community.feeds.present?
          redirect_to :action => "add_feeds"
        else
          redirect_to root_url
        end
      else
        render :edit_new
      end
    end
  end
  
  def subscribe_to_feeds
    current_user.feed_ids = params[:feed_ids]
    redirect_to root_url
  end

  def update
    current_user.update_attributes(params[:user])
  end
  
  def take_photo
    File.open("#{RAILS_ROOT}/tmp/#{current_user.id}_upload.jpg", 'w') do |f|
      f.write request.raw_post
    end
    current_user.avatar = File.new("#{RAILS_ROOT}/tmp/#{current_user.id}_upload.jpg")
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
  
end
