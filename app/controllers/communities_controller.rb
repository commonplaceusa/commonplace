class CommunitiesController < ApplicationController
  
  layout 'community'
  
  before_filter :load_community, :only => :index


  def show
    load_community
    @post = Post.new
  end

  protected
  
  def load_community
    unless @community = Community.find_by_name(params[:id])
      render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
    end
  end

end
