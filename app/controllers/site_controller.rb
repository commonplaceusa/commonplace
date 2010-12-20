class SiteController < CommunitiesController
  
  def privacy ; end

  def terms ; end
  
  def contact 
    render :layout => false
  end

end
