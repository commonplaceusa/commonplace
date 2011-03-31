class RequestsController < ApplicationController

  def index
    @requests = Request.all
  end

  def new
    @request = Request.new
  end

  
  def create
    @request = Request.new(params[:request])
    flash[:notice] = 'Thank you for requesting CommonPlace!'
    @request.save
    redirect_to('/')
  end
end
