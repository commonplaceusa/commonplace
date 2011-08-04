class AddCollegeFlagToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :is_college, :boolean, :default => false
  end

  def self.down
    remove_column :communities, :is_college
  end
end
