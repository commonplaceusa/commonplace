class CreateGroupMemberships < ActiveRecord::Migration
  def self.up
    create_table :group_memberships do |t|
      t.integer :member_id, :null => false
      t.integer :group_id, :null => false
      t.string :role
      t.timestamps
    end
  end

  def self.down
    drop_table :group_memberships
  end
end
