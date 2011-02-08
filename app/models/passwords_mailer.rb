class PasswordsMailer < ActionMailer::Base
  include Resque::Mailer
  
  @queue = :passwords
  
  def reset(user_id)
    @user = User.find(user_id)
    recipients @user.email
    from "passwords@commonplaceusa.com"
    subject "CommonPlace password reset"
    body "
<p>Follow this link to reset your password: #{edit_password_reset_url(@user.perishable_token, :host => "#{@user.community.slug}.ourcommonplace.com") }</p>
<br>
--
#{ @user.community.name }'s CommonPlace: #{@user.community.slug + '.ourcommonplace.com'}
"
  end
end
