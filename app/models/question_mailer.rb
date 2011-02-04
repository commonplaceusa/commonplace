class QuestionMailer < ActionMailer::Base
  
  helper :text
  helper_method :url
  include TextHelper

  include Resque::Mailer
  @queue = :notifications
  
  def faq(sender, question)
    @question_sender = sender
    @question_text = question
    recipients "jason@jasonberlinsky.com"
    header = SmtpApiHeader.new
    @headers['X-SMTPAPI'] = header.asJSON
    subject "New Question for you!"
    from "CommonPlace <do-not-reply@commonplaceusa.com>"
  end
  
end
