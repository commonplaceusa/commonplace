class NotifiedThingsPolymorphicOnNotifications < ActiveRecord::Migration
  def self.up
    remove_column :notifications, :user_id
    add_column :notifications, :notified_id, :integer
    add_column :notifications, :notified_type, :string
  end

  def self.down
    add_column :notifications, :user_id, :integer
    remove_column :notifications, :notified_id
    remove_column :notifications, :notified_type
  end
end
