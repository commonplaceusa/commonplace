class ChangeConversationToThreadOnMessages < ActiveRecord::Migration
  def self.up
    rename_column :messages, :conversation_id, :thread_id
    add_column :messages, :thread_type, :string
  end

  def self.down
    rename_column :messages, :thread_id, :conversation_id
    remove_column :messages, :thread_type
  end
end
