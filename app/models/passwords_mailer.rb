class PasswordsMailer < ActionMailer::Base
  
  
  def reset(user)
    recipients user.email
    from "passwords@commonplaceusa.com"
    subject "CommonPlace password reset"
    body <<END
<p>Follow this link to reset your password: #{edit_password_reset_url(user.perishable_token, :host => "ourcommonplace.com") }</p>
<br>
--
#{ user.community.name }'s CommonPlace: #{user.community.slug + ".ourcommonplace.com"}
END
  end
end
