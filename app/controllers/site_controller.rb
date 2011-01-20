class SiteController < CommunitiesController
  
  def privacy ; end

  def terms ; end
  
  def faq
    render :layout => 'application'
  end
end
