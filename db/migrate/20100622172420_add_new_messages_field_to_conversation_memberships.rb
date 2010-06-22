class AddNewMessagesFieldToConversationMemberships < ActiveRecord::Migration
  def self.up
    add_column :conversation_memberships, :new_messages, :boolean, :default => false
  end

  def self.down
    remove_column :conversation_memberships, :new_messages
  end
end
