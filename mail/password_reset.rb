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

  def user_name
    @user.full_name
  end

  def reset_url
    url("/users/password/edit?reset_password_token=#{@user.reset_password_token}")
  end

  def community_name
    community.name
  end

  def community
    user.community
  end

  def tag
    'password_reset'
  end

  def deliver?
    true
  end

  def self.queue
    :password_resets
  end

end
