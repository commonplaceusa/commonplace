class UnknownUser < MailBase

  def initialize(sender)
    @to = sender
  end

  def to
    @to
  end

  def tag
    'unknown_user'
  end

  def deliver?
    false
  end

end
