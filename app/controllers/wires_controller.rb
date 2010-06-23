class WiresController < ApplicationController

  def show
    @wire_posts = current_user.wire
  end

end