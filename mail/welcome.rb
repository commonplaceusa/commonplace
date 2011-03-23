class Welcome < MailBase

  def initialize(user)
    @user = user
    @community = user.community
  end

  def user
    @user
  end

  def community
    user.community
  end

  def community_name
    community.name
  end

  def short_user_name
    user.first_name
  end

  def organizer_email
    community.organizer_email
  end

  def subject
    "Welcome to CommonPlace"
  end
    
end
