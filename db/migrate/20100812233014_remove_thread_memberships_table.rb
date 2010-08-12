class RemoveThreadMembershipsTable < ActiveRecord::Migration
  def self.up
    drop_table :thread_memberships
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
