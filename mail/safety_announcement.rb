class SafetyAnnouncement < MailBase
  
  def initialize(user_id)
    @user = User.find(user_id)
  end

  def logo_url
    asset_url("logo2.png")
  end

  def subject
    "IMPORTANT - Hurricane Updates on OurCommonPlace"
  end

  def reply_to
    "max@ourcommonplace.com"
  end

  def from
    "Max Novendstern <max@ourcommonplace.com>"
  end

  def community
    user.community
  end

  def user
    @user
  end

  def user_name
    user.name
  end

  def tag
    'safety'
  end

  def short_user_name
    user.first_name
  end
end
