class AddAttemptedGeolocatingToUser < ActiveRecord::Migration
  def change
    add_column :users, :attempted_geolocating, :boolean
  end
end
