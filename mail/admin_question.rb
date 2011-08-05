class AdminQuestion < MailBase

  def initialize(sender, question, name)
    @sender, @question, @name = sender, question, name
  end

  def to
    "faq@commonplace.zendesk.com"
    #"jason@commonplaceusa.com"
  end

  def sender
    @sender
  end

  def name
    @name
  end

  def question
    @question
  end

  def subject
    "New CommonPlace Question"
  end

  def from
    "#{name} <#{sender}>"
  end

end
