class AddHouseholdCountToCommunities < ActiveRecord::Migration
  def self.up
    add_column :communities, :households, :integer, :default => 0
  end

  def self.down
    remove_column :communities, :households
  end
end
