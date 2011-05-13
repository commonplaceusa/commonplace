class AddLatitudeAndLongitudeToNeighborhoods < ActiveRecord::Migration
  def self.up
    add_column :neighborhoods, :latitude, :decimal
    add_column :neighborhoods, :longitude, :decimal
  end

  def self.down
    remove_column :neighborhoods, :latitude
    remove_column :neighborhoods, :longitude
  end
end
