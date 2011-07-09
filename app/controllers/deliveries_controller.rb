class DeliveriesController < AdministrationController
  
  def index
    @deliveries = ActionMailer::Base.deliveries.sort_by(&:date).reverse
  end
    

end
