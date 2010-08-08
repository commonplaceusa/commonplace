class AccountsController < ApplicationController

  filter_access_to :all

  def new
    
  end
  
  def create
    @user = User.new(params[:user])
    @user.community = Community.first
    
    respond_to do |format|
      if @user.save
        reload_current_user!
        format.json      
      else
        format.json { render :new }
      end
    end
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to account_url
    else
      render :edit
    end
  end

  def show
    @user = current_user
  end
  
end
