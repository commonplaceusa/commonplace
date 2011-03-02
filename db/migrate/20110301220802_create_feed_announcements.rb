class CreateFeedAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :feed_announcements do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :feed_announcements
  end
end
