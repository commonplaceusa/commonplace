class RemoveAboutFromNeighborhoods < ActiveRecord::Migration
  def self.up
    remove_column :neighborhoods, :about
  end

  def self.down
    add_column :neighborhoods, :about, :text
  end
end
