class OrganizationsController < ApplicationController
  
  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.find_by_id(params[:id])
    @events = Event.find(:all, :conditions => ["organization_id = ?", @organization.id])
  end
  
  def edit
    @organization = Organization.find_by_id(params[:id])
  end
  
  def new
    @organization = Organization.new
    render :new, :layout => "public"
  end
  
  def create
    @organization = Organization.new(params[:organization])
    respond_to do |format|
     if @organization.save
       format.html { redirect_to root_url }
       format.json         
     else
       format { render 'new' }
     end
   end
  end
  
  def update
  end
  
end
