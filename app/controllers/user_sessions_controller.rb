class UserSessionsController < ApplicationController

  before_filter :obfuscate_facebook_passcode

  def obfuscate_facebook_passcode
    if params[:user_session].present? and params[:user_session][:facebook_uid].present?
      params[:user_session][:password] = $CryptoKey.encrypt(params[:user_session][:facebook_uid])
    end
  end
  
  def new
    if logged_in?
      redirect_to root_url
      return
    end
    @user = User.new
  end

  def create
    if params[:user_session][:facebook_uid].present?
      facebook_uid = params[:user_session][:facebook_uid]
    end

    current_user_session.remember_me = true
    if current_user_session.save
      respond_to do |wants|
        wants.html {
          reload_current_user!
          redirect_back_or_default "/"
        }
        wants.js {
          render :action => "redirect"
        }
      end
    else
      @user = User.new
      params[:action] = "new"
      respond_to do |wants|
        wants.html {
          render :new
        }
        wants.js
      end
    end
  end

  def show
    redirect_to root_url
  end

  def destroy
    redirect_to login_url(current_community)
    current_user_session.destroy
  end

end
