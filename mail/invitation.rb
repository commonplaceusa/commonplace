class Invitation < MailBase

  def initialize(email, inviter_id, message = nil)
    @to = email
    @inviter = User.find(inviter_id)
    @message = message.present? ? message : nil
  end

  def subject
    "#{inviter_name} invites you to #{community_name}'s CommonPlace"
  end

  def to
    @to
  end

  def inviter
    @inviter
  end

  def message
    @message
  end

  def community
    inviter.community
  end

  def community_name
    community.name
  end

  def inviter_name
    inviter.name
  end

  def short_inviter_name
    inviter.first_name
  end

  def organizer_name
    community.organizer_name
  end
  
  def organizer_email
    community.organizer_email
  end

end
