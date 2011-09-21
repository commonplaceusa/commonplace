class BootstrapsController < ApplicationController

  # these actions give just a little bit of information to the browser before
  # handing things over to Backbone.js

  layout false
  
  before_filter :authenticate_user!

  def community ; end

  def feed ; end

  def group ; end

end
