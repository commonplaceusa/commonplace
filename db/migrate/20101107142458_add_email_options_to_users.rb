class AddEmailOptionsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :receive_posts, :boolean, :default => true
    add_column :users, :receive_events_and_announcements, :boolean, :default => true
  end

  def self.down
    remove_column :users, :receive_posts
    remove_column :users, :receive_events_and_announcements
  end
end
