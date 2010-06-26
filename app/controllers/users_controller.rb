class UsersController < ApplicationController


  def index
    if params[:q]
      @users = User.all(:conditions => ['first_name LIKE ? OR last_name LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%"], :limit => 5)
      render 'autocomplete'
    else
      @users = User.all
    end
  end


end
