class PasswordResetsController < Devise::PasswordsController
  layout 'sign_in'

  def create
    user = User.find_by_email(params[:user][:email])
    if user
      user.send_reset_password_instructions
      flash[:notice] = "You have been e-mailed password reset instructions."
      redirect_to '/login_password_reset'
    else
      flash[:error] = "The e-mail address you entered is not registered with CommonPlace. Register for CommonPlace or e-mail <a href='mailto: support@commonplaceusa.com'>support@commonplaceusa.com</a> for assistance."
      render :new
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(params[resource_name])

    if resource.errors.empty?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      set_flash_message(:notice, "Unable to reset your password. Please try again.")
      respond_with resource
    end
  end
end
