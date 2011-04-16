class UnknownUser < MailBase

  def initialize(sender)
    @to = sender
  end

  def to
    @to
  end

end
