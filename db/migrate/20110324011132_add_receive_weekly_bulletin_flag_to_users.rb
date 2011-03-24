class AddReceiveWeeklyBulletinFlagToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :receive_weekly_digest, :boolean, :default => true
    User.reset_column_information 
    User.find_each do |user|
      if !user.receive_posts && !user.receive_events_and_announcements
        user.receive_weekly_digest = false
        user.save!
      end
    end
  end

  def self.down
    remove_column :users, :receive_weekly_digest
  end
end
