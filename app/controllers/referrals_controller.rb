class ReferralsController < ApplicationController

  def create
    @event = Event.find(params[:event_id])
    @referral = @event.referrals.build(params[:referral].merge(:referrer => current_user))
    if @referral.save
      render 'show'
    else
      render 'new'
    end
  end
                                       
end
