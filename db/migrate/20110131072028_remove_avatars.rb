class RemoveAvatars < ActiveRecord::Migration
  def self.up
    drop_table :avatars
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
