class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.integer :linkable_id, :null => false
      t.string :linkable_type, :null => false
      t.integer :linker_id, :null => false
      t.string :linker_type, :null => false
      t.timestamps
    end
    drop_table :group_memberships
    drop_table :attendances
    drop_table :sponsorships
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
