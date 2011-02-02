class MessagesBelongToMessagable < ActiveRecord::Migration
  def self.up
    rename_column :messages, :recipient_id, :messagable_id
    add_column :messages, :messagable_type, :string
    
    Message.reset_column_information
    
    Message.find_each do |message|
      message.messagable_type = "User"
      message.save!
    end
  end

  def self.down
    if Message.exists?(:conditions => ["messagable_type != 'User'"])
      raise "Message exists with non-User messagable_type"
    end

    rename_column :messages, :messagable_id, :recipient_id
    remove_column :messages, :messagable_type
  end
end
