class Administration::AddressesController < AdministrationController

  def index
    @addresses = Address.all
  end
  
  def create
    @address = Address.new(params[:address])
    @address.save
    respond_to do |format|
      format.json { render :json => @address }
    end
  end
  

end
