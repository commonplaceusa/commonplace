class AddLatitudeAndLongitudeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :latitude, :decimal
    add_column :users, :longitude, :decimal
  end

  def self.down
    remove_column :users, :latitude
    remove_column :users, :longitude
  end
end
