class SiteController < CommunitiesController

  layout 'application'
  
  def privacy ; end

  def terms ; end
  
  def faq ; end
  
  def faq_parse
    render :nothing => true
    QuestionMailer.deliver_faq(params[:email_address],params[:message])
  end
end
