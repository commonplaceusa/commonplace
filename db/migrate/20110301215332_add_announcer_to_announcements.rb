class AddAnnouncerToAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :announcements, :announcer_id, :integer
    add_column :announcements, :announcer_type, :string
    Announcement.find(:all).each do |announcement|
      announcement.announcer_id = anouncement.feed_id
      announcement.announcer_type = "Feed"
      announcement.save!
    end
    remove_column :announcements, :feed_id
  end

  def self.down
    add_column :announcements, :feed_id, :integer
    Announcement.find(:all).each do |announcement|
      if announcement.type == "Feed"
        announcement.feed_id = announcement.announcer_id
      end
    end
    remove_column :announcements, :announcer_id
    remove_column :announcements, :announcer_type
  end
end
