class SiteController < ApplicationController

  layout 'application'

  def privacy ; end

  def terms ; end

  def about
    render layout: nil and return unless request.try(:location).try(:latitude).present? and request.try(:location).try(:longitude).present?
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
            slug: community.slug,
            name: community.name
          }
        end.sort_by { |h| h[:distance] }

        # Filter communites by cut-off distance
        closest_community.reject! {|h| CoordinateDistance.cutoff(h) }

        # If there are more than one community left [or none at all],
        # render the default about page
        if closest_community.count != 1
          render layout: nil and return if params[:comm].nil?

          name = params[:comm].split(",").first
          if c = Community.find_by_name(name)
            redirect_to "/#{c.slug}" and return
          else
            render layout: nil and return
          end
        end

        # Found exactly one community within the cut-off
        closest_community = closest_community.first

        redirect_to "/#{closest_community[:slug]}/about" and return
      rescue => ex
        render layout: nil and return
      end
    end
    render layout: nil
  end

  def info
    render layout: nil and return unless request.try(:location).try(:latitude).present? and request.try(:location).try(:longitude).present?
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
            slug: community.slug,
            name: community.name
          }
        end.sort_by { |h| h[:distance] }

        # Filter communites by cut-off distance
        closest_community.reject! {|h| CoordinateDistance.cutoff(h) }

        # If there are more than one community left [or none at all],
        # render the default landing page
        if closest_community.count != 1
          render layout: nil and return if params[:comm].nil?

          name = params[:comm].split(",").first
          if name.present? and c = Community.find_by_name(name)
            redirect_to "/#{c.slug}" and return
          else
            render layout: nil and return
          end

        end

        # Found exactly one community within the cut-off
        closest_community = closest_community.first
        redirect_to "/#{closest_community[:slug]}" and return
      rescue => ex
        render layout: nil and return
      end
    end
    render layout: nil
  end
end
