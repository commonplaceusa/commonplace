class BootstrapsController < ApplicationController

  # these actions give just a little bit of information to the browser before
  # handing things over to Backbone.js

  layout false
  
  before_filter :authenticate_user!, :except => :registration

  def community 
    redirect_to "/#{current_community.slug}"
  end

  def feed ; end

  def group ; end

  def application ; end

  def registration 
    if current_community.nil?
      render(
        :file => Rails.root.join("public", "404.html"), 
        :layout => false, 
        :status => 404
        )
    end
  end

  def organizer_app ; end

end
