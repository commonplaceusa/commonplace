class RemoveLatAndLngFromCommunities < ActiveRecord::Migration
  def self.up
    remove_column :communities, :lat
    remove_column :communities, :lng
  end

  def self.down
    add_column :communities, :lat, :decimal
    add_column :communities, :lng, :decimal
  end
end
