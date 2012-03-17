class AccountsController < ApplicationController

  layout 'application'

  def avatar ; end

  def crop_avatar
    current_user.update_attributes params[:user]
    redirect_to "/" + current_user.community.slug + "/account"
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

end
