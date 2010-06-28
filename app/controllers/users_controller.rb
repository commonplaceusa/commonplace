class UsersController < ApplicationController


  def index
    if params[:term]
      @users = User.all(:conditions => ['first_name LIKE ? OR last_name LIKE ?', "%#{params[:q]}%", "%#{params[:term]}%"], :limit => 5)
      render 'autocomplete', :layout => false
    else
      @users = User.all
    end
  end


end
