class OrganizerController < ApplicationController
  def map
    @addresses = cp_client.addresses_for_community(current_community)
    #@data_points = cp_client.organizer_entries_for_community(current_community)
    @center_zip_code = current_community.zip_code
  end
end
