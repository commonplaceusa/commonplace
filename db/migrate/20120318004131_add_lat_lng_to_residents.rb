class AddLatLngToResidents < ActiveRecord::Migration
  def change
    add_column :residents, :latitude, :decimal
    add_column :residents, :longitude, :decimal
  end
end
