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
  
  def send_faq
    Resque.enqueue(AdminQuestion, params[:email_address], params[:message])
    redirect_to faq_url
  end
end
