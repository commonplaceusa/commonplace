class AccountsController < ApplicationController
  
  def new
    authorize! :new, User
    @user = User.new
    render :layout => false
  end
  
  def create
    params[:user][:privacy_policy] = params[:user][:privacy_policy].last if params[:user][:privacy_policy].is_a?(Array)
    authorize! :create, User
    @location = Location.new(params[:user].delete(:location))
    @neighborhood = current_community.neighborhoods.first
    @user = @neighborhood.users.build(params[:user])
    if @user.save
      @location.save
      redirect_to edit_account_url
    else
      render :new, :layout => false
    end
  end

  def edit
    @user = current_user
    @items = @user.wire
    render :layout => false
  end

  def update

    authorize! :update, User
    if current_user.update_attributes(params[:user]) || true
      redirect_to new_first_post_url
    else
      render :edit
    end
  end

end
