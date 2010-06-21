class CreateConversationMemberships < ActiveRecord::Migration
  def self.up
    create_table :conversation_memberships do |t|
      t.integer :user_id, :null => false
      t.integer :conversation_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :conversation_memberships
  end
end
