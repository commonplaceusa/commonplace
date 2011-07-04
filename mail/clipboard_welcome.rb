class ClipboardWelcome < MailBase

  def initialize(user_id)
    @user = HalfUser.find(user_id)
    @community = user.community
  end

  def user
    @user
  end

  def community
    @community
  end

  def community_name
    community.name
  end

  def community_slug
    community.slug
  end

  def short_user_name
    user.first_name
  end

  def organizer_email
    community.organizer_email
  end

  def organizer_name
    community.organizer_name
  end

  def subject
    "Welcome to #{community_name}'s CommonPlace!"
  end

  def single_access_login
    url("/account/gatekeeper?husat=#{user.single_access_token}")
  end

end
