class SpamReportReceivedNotification < MailBase

  def initialize(user_id)
    @user = User.find(user_id)
  end

  def subject
    "Spam Report Received"
  end

  def reply_to
    "postmaster@ourcommonplace.com"
  end

  def user
    @user
  end

  def community_name
    community.name
  end

  def community
    user.community
  end

  def user_name
    user.name
  end

  def short_user_name
    user.first_name
  end

  def tag
    'spam_report'
  end

  def deliver?
    false
  end

end
