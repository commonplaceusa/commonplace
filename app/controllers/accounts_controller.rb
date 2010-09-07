class AccountsController < ApplicationController

  filter_access_to :all

  def new
    
  end
  
  def create
    @neighborhood = Neighborhood.find_for(params[:user][:address])
    @user = @neighborhood.users.build(params[:user])
    respond_to do |format|
      if @user.save
        reload_current_user!
        format.json
        format.html
      else
        format.json { render :new }
        format.html { render :new }
      end
    end
  end

  def edit
    @user = current_user
    render :layout => 'management'
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to management_url
    else
      render :edit
    end
  end

  def show
    @user = current_user
  end
  
end
