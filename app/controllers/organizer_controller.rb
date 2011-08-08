class OrganizerController < ApplicationController
  def map
    @addresses = current_community.users.map &:address
    @data_points = current_community.organizers.map(&:organizer_data_points).flatten.select { |p| p.present? }
    @center_zip_code = current_community.zip_code
  end
end
