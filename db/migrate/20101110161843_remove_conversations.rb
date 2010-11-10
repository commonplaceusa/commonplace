class RemoveConversations < ActiveRecord::Migration
  def self.up
    drop_table :conversations
    drop_table :conversation_memberships
    remove_column :messages, :conversation_id
    add_column :messages, :subject, :string
    add_column :messages, :recipient_id, :integer
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
