class PasswordReset < MailBase

  def initialize(user_id)
    @user = User.find(user_id)
  end

  def subject
    "CommonPlace password reset"
  end

  def from
    "passwords@commonplaceusa.com"
  end

  def user
    @user
  end

  def reset_url
    url("/password_resets/#{user.perishable_token}/edit")
  end

  def community_name
    community.name
  end

  def community
    user.community
  end
end
