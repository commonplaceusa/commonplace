class PasswordResetsController < CommunitiesController

  def new
    @email = ""
  end

  def create
    if @user = User.find_by_email(params[:email])
      @user.reset_perishable_token!
      PasswordsMailer.deliver_reset(@user)
      render :show
    else
      flash.now[:error] = "That email address is not in our system"
      render :new
    end
  end

  def edit
    if @user = User.find_using_perishable_token(params[:id])
      render
    else
      redirect_to new_password_reset_url
    end
  end

  def update
    if @user = User.find_using_perishable_token(params[:id])
      @user.password = params[:user][:password]
      if @user.save!
        redirect_to root_url
      else
        render :edit
      end
    else
      redirect_to new_password_reset_url
    end
  end
  
end
