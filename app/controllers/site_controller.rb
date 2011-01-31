class SiteController < CommunitiesController
  
  def privacy ; end

  def terms ; end
  
  def faq
    render :layout => 'application'
  end
  
  def faq_parse
    render :nothing => true
    QuestionMailer.deliver_faq(params[:email_address],params[:message])
  end
end
