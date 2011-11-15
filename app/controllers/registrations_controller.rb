class RegistrationsController < ApplicationController
  layout 'registration'

  before_filter :authenticate_user!, :except => [:new, :facebook_new, :create]

  def new
    if current_community
      session["devise.community"] = current_community.id # used for facebook connection
      @user = User.new(:community => current_community)
    else
      redirect_to '/'
    end
  end

  def facebook_new
    # this action is actually rendered in
    # UsersOmniAuthCallbacksController#facebook
    @user = current_user
  end

  def create # necessary for devise sign_in method
    # assume xhr
    unless params[:registration].present?
      render :json => {message: 'No information sent'}
      return
    end

    user = User.create(params[:registration])
    if user.save
      sign_in(user, :bypass => true)
      kickoff.deliver_welcome_email(user)
      render :json => {first_name: user.first_name}
    else
      render :json => {errors: user.errors.messages}
    end

  end

end