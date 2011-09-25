class AccountsController < ApplicationController

  layout 'application'

  protect_from_forgery :except => :update

  before_filter :authenticate_user!

  def delete
  end

  def destroy
    current_user.destroy
    redirect_to root_url
  end
  
  def edit
    if can? :edit, current_user
      render :layout => 'application'
    else
      redirect_to '/users/sign_in'
    end
  end

  def settings
    if current_user.update_attributes(params[:user])
      sign_in(current_user, :bypass => true)
      redirect_to root_url
    else
      render :edit
    end
  end

  def update
    current_user.update_attributes(params[:user])
    sign_in(current_user, :bypass => true)
    redirect_to root_url
  end
  
  def learn_more
    unless current_community.present?
      redirect_to root_url
    end
  end

  def facebook_invite
    # Twitter doesn't like https...
    unless logged_in?
      raise CanCan::AccessDenied
    end
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
  
end
