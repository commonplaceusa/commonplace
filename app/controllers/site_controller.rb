class SiteController < ApplicationController

  layout 'application'

  def privacy ; end

  def terms ; end

  def info
    render layout: nil unless request.location.latitude.present? and request.location.longitude.present?
    unless params[:locate] == "false"
      # Get user's location from IP Address
      # Send them to the right community's about page
      begin
        closest_community = Community.all.map do |community|
          {
            distance: CoordinateDistance.distance(
                request.location,
                {
                  latitude: community.latitude,
                  longitude: community.longitude
                }),
            slug: community.slug
          }
        end.sort_by { |h| h[:distance] }.first
        redirect_to "/#{closest_community[:slug]}/about" and return if closest_community[:distance] <= 2
      rescue => ex
        raise "#{ex.message}. REQUEST LOCATION: #{request.location.inspect}"
      end
    end
    render layout: nil
  end
end
