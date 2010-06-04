class AccountsController < ApplicationController

  def show 
    @user = current_user
  end

  def new
    @account = Account.new(params[:account])
  end
  
  def create    
    @account = Account.new(params[:account])
    if @account.save
      reload_current_user!
      render :more_info
    else
      render :new
    end
  end

  def edit ; end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to community_page
    else
      render :edit
    end
  end

  
end
