class ClaimsController < CommunitiesController
  before_filter :organization

  def new
    render :layout => false
  end
  
  def create
    if params[:code] == @organization.code
      @organization.admins << current_user
      @organization.claimed = true
      @organization.save
      redirect_to edit_organization_url(@organization)
    else
      flash.now[:error] = "Sorry, that claim code is not valid."
      render :new
    end
  end

  def edit
    respond_to do |format|
      format.json 
    end
  end

  def update
    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.json 
      else
        format.json
      end
    end
  end

  def edit_fields
    respond_to do |format|
      format.json
    end
  end

  protected

  def organization
    @organization = Organization.find(params[:organization_id])

  end

end
