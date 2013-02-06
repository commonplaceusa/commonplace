class RequestsController < ApplicationController

  def create
    # @request = Request.new(params[:request])
    flash[:notice] = 'Thank you for requesting CommonPlace!'
    # @request.save
    redirect_to('/')
  end

end
