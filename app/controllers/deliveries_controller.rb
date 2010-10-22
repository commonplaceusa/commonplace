class DeliveriesController < AdministrationController
  
  def index
    @deliveries = ActionMailer::Base.deliveries
  end
    

end
