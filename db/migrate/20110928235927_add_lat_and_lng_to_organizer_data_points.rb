class AddLatAndLngToOrganizerDataPoints < ActiveRecord::Migration
  def change
    add_column :organizer_data_points, :lat, :float
    add_column :organizer_data_points, :lng, :float
    add_column :organizer_data_points, :attempted_geolocating, :boolean
  end
end
