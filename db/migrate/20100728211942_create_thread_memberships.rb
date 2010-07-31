class CreateThreadMemberships < ActiveRecord::Migration
  def self.up
    create_table :thread_memberships do |t|
      t.integer :thread_id, :null => false
      t.string :thread_type, :null => false
      t.integer :user_id, :null => false
      t.string :current_state, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :thread_memberships
  end
end
