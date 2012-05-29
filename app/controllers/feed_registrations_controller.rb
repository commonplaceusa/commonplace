class FeedRegistrationsController < ApplicationController
  
  helper_method :registration
  
  layout 'feed_registration'

  before_filter :authenticate_user!
  
  def new ; end

  def create
    registration.attributes = params[:feed]
    if registration.save
      if registration.has_avatar?
        redirect_to avatar_feed_registration_url(registration)
      else
        redirect_to profile_feed_registration_url(registration)
      end
    else
      render :new
    end
  end

  def avatar ; end

  def crop_avatar
    registration.update_attributes(params[:feed])
    redirect_to profile_feed_registration_url(registration)
  end

  def profile ; end

  def add_profile
    if registration.update_attributes params[:feed]
      #redirect_to subscribers_feed_registration_url(registration)
      redirect_to "/pages/#{registration.feed.slug.blank? ? registration.feed.id : registration.feed.slug}"
    else
      render :profile
    end
  end

  def subscribers ; end

  def invite_subscribers
    registration.invite_subscribers(params[:feed_subscribers])
    redirect_to "/pages/#{registration.feed.slug.blank? ? registration.feed.id : registration.feed.slug}"
  end

  protected

  def registration
    @registration ||= 
      FeedRegistration.find_or_create(:id => params[:id],
                                      :community => current_community,
                                      :user => current_user)
  end
end
