class OrganizerController < ApplicationController
  def map
    @addresses = current_community.users.map &:address
    @data_points = current_community.organizers.map(&:organizer_data_points).flatten.select { |p| p.present? }
    @center_zip_code = current_community.zip_code
  end

  def add
    @data_point = OrganizerDataPoint.new
    @data_point.organizer_id = current_user.id

    @data_point.address = params[:address]
    @data_point.status = params[:status]

    @data_point.save
    redirect_to :action => :map
  end

end
