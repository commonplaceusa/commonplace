class AdminQuestion < MailBase

  def initialize(sender, question)
    @sender, @question = sender, question
  end

  def to
    "faq@commonplaceusa.com"
  end

  def sender
    @sender
  end

  def question
    @question
  end

  def subject
    #"New Question for you!"
    "FAQ Question"
  end

  def from
    sender
  end

end
