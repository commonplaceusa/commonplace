class OrganizerController < ApplicationController
  def map
    @addresses = current_community.users.map &:address
    @data_points = current_community.organizers.map(&:organizer_data_points).flatten.select { |p| p.present? }
    @center_zip_code = current_community.zip_code.to_s
    @community_bias = "Falls Church, VA"
    @community_id = current_community.id
  end

  def add
    cp_client.add_data_point(current_community,params)
    redirect_to :action => :map
  end

end
