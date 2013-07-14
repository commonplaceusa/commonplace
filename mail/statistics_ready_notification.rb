class StatisticsReadyNotification < MailBase

  def initialize(email, name)
    @email = email
    @name = name
  end

  def community_name
    "Administration"
  end

  def short_user_name
    @name
  end

  def user
    User.find_by_email(@email)
  end

  def subject
    "CommonPlace Statistics Prepared!"
  end

  def tag
    'administrative'
  end

  def deliver?
    false
  end

end
