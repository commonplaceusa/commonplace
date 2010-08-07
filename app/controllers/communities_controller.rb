class CommunitiesController < ApplicationController

  def show
    respond_to do |format|
      format.json
      format.html
    end
  end

end
