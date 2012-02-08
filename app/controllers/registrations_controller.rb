class RegistrationsController < ApplicationController
  helper_method :registration
  layout 'registration'

  before_filter :authenticate_user!, :except => :base

end
