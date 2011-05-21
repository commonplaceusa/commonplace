class UserSessionsController < ApplicationController
  
  def new
    authorize! :new, UserSession
    @user = User.new
  end

  def create
    authorize! :create, UserSession
    if params[:user_session][:facebook_uid].present?
      facebook_uid = params[:user_session][:facebook_uid]
    end
    puts params.inspect
    puts facebook_uid

    current_user_session.remember_me = true
    if current_user_session.save
      respond_to do |wants|
        wants.html {
          reload_current_user!
          redirect_back_or_default root_url
        }
        wants.js {
          render :action => "redirect"
        }
      end
    else
      @user = User.new
      params[:controller] = "accounts"
      params[:action] = "new"
      respond_to do |wants|
        wants.html {
          render 'accounts/new'
        }
        wants.js
      end
    end
  end

  def show
    redirect_to root_url
  end

  def destroy
    authorize! :destroy, UserSession
    current_user_session.destroy
    redirect_to root_url
  end

end
