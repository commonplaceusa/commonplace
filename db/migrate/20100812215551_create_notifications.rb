class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :user_id, :null => false
      t.integer :notifiable_id, :null => false
      t.string :notifiable_type, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
