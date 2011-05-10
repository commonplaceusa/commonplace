class AdminQuestion < MailBase

  def initialize(sender, question)
    @sender, @question = sender, question
  end

  def to
    "petehappens@gmail.com"
  end

  def sender
    @sender
  end

  def question
    @question
  end

  def subject
    "New Question for you!"
  end

  def from
    "CommonPlace <do-not-reply@commonplaceusa.com>"
  end

end
