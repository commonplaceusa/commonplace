class WiresController < ApplicationController

  def show
    render index
  end

  def index
    @wire_posts = current_user.wire
  end

end