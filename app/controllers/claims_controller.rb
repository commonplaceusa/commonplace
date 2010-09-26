class ClaimsController < CommunitiesController
  before_filter :organization

  def new
    respond_to do |format|
      format.json
    end
  end
  
  def create
    respond_to do |format|
      if params[:code] == @organization.code
        @organization.admins << current_user
        @organization.claimed = true
        @organization.save
        format.json { render :create }
      else
        format.json { render :new }
      end
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
