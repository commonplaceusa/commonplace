class UnknownAddress < MailBase

  def initialize(user_id)
    @user = User.find(user_id)
  end

  def subject
    "CommonPlace post did not go through"
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

  def organizer_email
    community.organizer_email
  end

end
