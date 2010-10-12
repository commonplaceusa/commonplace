class DeliveriesController < ApplicationController

  def index
    @deliveries = ActionMailer::Base.deliveries
  end
    

end
