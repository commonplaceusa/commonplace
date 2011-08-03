class AdminQuestion < MailBase

  def initialize(sender, question, name)
    @sender, @question, @name = sender, question, name
  end

  def to
    "petehappens@gmail.com"
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
    "New Question for you!"
  end

  def from
    @sender
    "#{name} <#{sender}>"
  end

end
