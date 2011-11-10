class RegistrationsController < ApplicationController
  helper_method :registration
  layout 'registration'

  before_filter :authenticate_user!, :except => [:new, :create, :facebook_new, :mobile_new]

  def new
    if current_community
      session["devise.community"] = current_community.id
    else
      @request = Request.new()
      render 'site/index', :layout => 'starter_site'
    end
  end

  def mobile_new
    render :layout => 'mobile_registration'
  end
  
  def facebook_new
    # this action is actually rendered in
    # UsersOmniAuthCallbacksController#facebook
  end

  def create
    registration.attributes = params[:user]
    if registration.save
      sign_in(registration.user, :bypass => true)
      kickoff.deliver_welcome_email(registration.user)
      redirect_to profile_registration_url
    else
      render :new
    end
  end

  def profile ;  end

  def mobile_profile 
    render :layout => 'mobile_registration'
  end

  def add_profile
    if registration.update_attributes params[:user]
      sign_in(registration.user, :bypass => true)
      if registration.has_avatar?
        redirect_to avatar_registration_url
      else
        redirect_to feeds_registration_url
      end
    else
      render :profile
    end
  end

  def avatar ; end

  def crop_avatar
    registration.update_attributes params[:user]
    redirect_to feeds_registration_url
  end

  def feeds
    if current_community.feeds.present?
      render
    else
      redirect_to groups_registration_url
    end
  end

  def add_feeds
    registration.add_feeds(params[:feed_ids])
    redirect_to groups_registration_url
  end

  def groups
    if current_community.feeds.present?
      render
    else
      redirect_to root_url
    end
  end

  def add_groups
    registration.add_groups(params[:group_ids])
    redirect_to(root_url + "#/tour")
  end

  protected

  def registration 
    @registration ||= 
      Registration.new(current_user || User.new(:community => current_community))
  end
  

end
