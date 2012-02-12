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

  def subject
    "Welcome to #{community_name}'s CommonPlace!"
  end

  def tag
    'administrative'
  end

  def deliver?
    true
  end

end
