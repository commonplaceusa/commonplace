class PolygonalNeighborhoodBounds < ActiveRecord::Migration
  def self.up
    add_column :neighborhoods, :bounds, :text
    remove_column :neighborhoods, :north_bound
    remove_column :neighborhoods, :south_bound
    remove_column :neighborhoods, :east_bound
    remove_column :neighborhoods, :west_bound
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
