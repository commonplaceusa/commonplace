class CommunitiesController < ApplicationController

  def good_neighbor_discount
    render :layout => "application"
  end

  def faq ; end
  
  def send_faq
    kickoff.deliver_admin_question(params[:email_address], params[:message], params[:name])
    redirect_to faq_url
  end

end
