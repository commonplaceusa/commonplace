class AccountsController < ApplicationController
  
  def new
    authorize! :new, User
  end
  
  def create
    authorize! :create, User
    @neighborhood = current_community.neighborhoods.first
    @user = @neighborhood.users.build(params[:user])
    if @user.save
      reload_current_user!
      redirect_to root_url
    else
      render 'user_sessions/new'
    end
  end

  def edit
    authorize! :edit, User
    @user = current_user
    render :layout => 'management'
  end

  def update
    authorize! :update, User
    if current_user.update_attributes(params[:user])
      redirect_to management_url
    else
      render :edit
    end
  end

end
