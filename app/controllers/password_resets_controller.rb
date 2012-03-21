class PasswordResetsController < Devise::PasswordsController
  layout 'sign_in'

  def create
    user = User.find_by_email(params[:user][:email])
    if user
      user.send_reset_password_instructions
      flash[:notice] = "An email will be sent to #{user.email} containing password reset instructions."
      redirect_to new_user_session_url
    else
      render :new
    end
  end
end
