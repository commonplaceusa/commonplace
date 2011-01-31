class RemoveLocations < ActiveRecord::Migration
  def self.up
    drop_table :locations
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
