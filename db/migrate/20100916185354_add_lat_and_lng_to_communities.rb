class AddLatAndLngToCommunities < ActiveRecord::Migration
  def self.up
    add_column :communities, :lat, :decimal
    add_column :communities, :lng, :decimal
  end

  def self.down
    remove_column :communities, :lat
    remove_column :communities, :lng
  end
end
