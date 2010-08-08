class AccountsController < ApplicationController

  filter_access_to :all

  def new

  end
  
  def create    
    respond_to do |format|
      format.json
    end
    # @user = User.new(params[:user].merge(:community => Community.first))
    # if @user.save
    #   reload_current_user!
    #   render :more_info
    # else
    #   render :new
    # end
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
