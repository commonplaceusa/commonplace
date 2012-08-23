class AddLatitudeAndLongitudeToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :latitude, :decimal, default: 0
    add_column :communities, :longitude, :decimal, default: 0
  end
end
