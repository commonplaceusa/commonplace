class Welcome < MailBase

  def initialize(user_id)
    @user = User.find(user_id)
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
    "Welcome to #{community_name}'s CommonPlace"
  end
    
end
