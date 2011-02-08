class RemoveUnusedTables < ActiveRecord::Migration
  def self.up
    drop_table :addresses
    drop_table :notifications
    drop_table :profile_fields
    drop_table :slugs
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
