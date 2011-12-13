class FeedsController < ApplicationController
  before_filter :load

  def delete
    render :layout => 'application'
  end

  def destroy
    @feed.destroy
    redirect_to root_url
  end

  def edit_owner
    render :layout => 'application'
  end

  def update_owner
    if user = User.find_by_email(params[:email])
      @feed.user = user
      @feed.owners << user
      @feed.save
      redirect_to root_url
    else
      @error = true
      render :edit_owner, :layout => 'application'
    end
  end

  def edit
    render :layout => 'feed_registration'
  end

  def avatar 
    render :layout => 'feed_registration'
  end

  def crop_avatar
    @feed.update_attributes(params[:feed])
    redirect_to feed_profile_path(@feed)
  end

  def update
    if @feed.update_attributes(params[:feed])
      if params[:feed].has_key?(:avatar)
        redirect_to :action => :avatar
      else
        redirect_to feed_profile_path(@feed)
      end
    else
      render :edit, :layout => 'feed_registration'
    end
  end
  
  protected
  def load
    @feed = 
      case params[:id]
      when /^\d+$/
        Feed.find(params[:id])
      when /[^\d]/
        params[:action] = "profile"
        Feed.find_by_slug_and_community_id(params[:id], current_community.id)
      else
        Feed.new
      end
  end

  def feed_profile_path(feed)
    "/pages/#{feed.slug.blank? ? feed.id : feed.slug}"
  end
end
