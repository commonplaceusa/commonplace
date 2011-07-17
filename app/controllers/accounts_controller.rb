class AccountsController < ApplicationController

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
      redirect_to login_url
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
    redirect_to root_url
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
    # Twitter doesn't like https...
    if request.ssl?
      redirect_to :protocol => "http://"
    end
    @invitation = Invite.new
  end

  def make_focp
    user = User.find_by_email(params[:email])
    slug = user.community.slug

    # TODO: Get an auth token
    url = URI.parse('https://www.google.com/accounts/ClientLogin')
    req = Net::HTTP::Post.new(url.path)
    req.add_field('Content-type', 'application/x-www-form-urlencoded')
    data = "&Email=jason%40commonplaceusa%2Ecom&Passwd=601845jrB&accountType=HOSTED&service=apps"
    req.form_data = data
    con = Net::HTTP.new(url.host, url.port)
    con.use_ssl = true
    res = con.start { |http| http.request(req) }
    logger.info res.body

    url = URI.parse('https://apps-apis.google.com/a/feeds/group/2.0/commonplace.in/friendsofcommonplace' + slug + '@commonplace.in')
    req = Net::HTTP::Post.new(url.path)
    req.add_field('Content-type', 'application/atom+xml')
    req.add_field('Authorization', 'GoogleLogin auth=' + auth_token)
    data = '<?xml version="1.0" encoding="UTF-8"?><atom:entry xmlns:atom="http://www.w3.org/2005/Atom" xmlns:apps="http://schemas.google.com/apps/2006" xmlns:gd="http://schemas.google.com/g/2005"><apps:property name="memberId" value="' + params[:email] + '"/></atom:entry>'
    req.form_data = data
    con = Net::HTTP.new(url.host, url.port)
    con.use_ssl = true
    con.start { |http| http.request(req) }

    render :nothing => true
  end

  def profile
    authorize! :update, User
  end

  def gatekeeper
    if halfuser = HalfUser.find_by_single_access_token(params[:husat])
      current_user.full_name = halfuser.full_name
      current_user.email = halfuser.email
      current_user.community_id = halfuser.community_id
      current_user.address = halfuser.street_address
      @user = current_user
    else
      redirect_to root_url
    end
  end
end
