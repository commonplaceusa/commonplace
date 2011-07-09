class Administration::CommunitiesController < ApplicationController
  layout 'administration'

  def index
    @communities = Community.all
  end

  def new
    @community = Community.new
    @community.neighborhoods = [Neighborhood.new]
    render :layout => "administration"
  end

  def create
    params[:community][:neighborhoods_attributes].each do |i,n|
      n[:bounds] = YAML::load(n[:bounds])
    end
    @community = Community.new(params[:community])
    if @community.save
      redirect_to communities_url
    else
      render :new
    end
  end

  def edit
    @community = Community.find params[:id]
  end

  def update
    @community = Community.find params[:id]
    if @community.update_attributes(params[:community])
      logger.info @community.inspect
      redirect_to communities_url
    else
      render :edit
    end
  end
end
