class Administration::OrganizationsController < AdministrationController

  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(params[:organization])
    if @organization.save
      redirect_to :index
    else
      render :new
    end
  end

  def edit
    @organization = Organization.find(params[:id])
  end
                                      
    
end
