class Invitation < MailBase

  def initialize(email, inviter, message = nil)
    @to = email
    @inviter = inviter
    @message = message
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
  
  
end
