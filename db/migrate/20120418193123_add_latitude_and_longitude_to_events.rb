class AddLatitudeAndLongitudeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :latitude, :decimal
    add_column :events, :longitude, :decimal
  end
end
