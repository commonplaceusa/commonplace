class AddTimezoneToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :time_zone, :string, :default => "Eastern Time (US & Canada)"
  end

  def self.down
    remove_column :communities, :time_zone
  end
end
