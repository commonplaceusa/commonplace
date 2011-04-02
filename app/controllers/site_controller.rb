class SiteController < ApplicationController

  layout 'application'

  def index 
    @request = Request.new
    render :layout => 'starter_site'
  end
  
  def interns
    @internship = Internship.new
    render :layout => 'internship_page'
  end

  def privacy ; end

  def terms ; end
  
  def faq ; end
  
  def faq_parse
    render :nothing => true
    QuestionMailer.deliver_faq(params[:email_address],params[:message])
  end
end
