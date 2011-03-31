class UserAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :announcements, :owner_type, :string
    add_column :announcements, :owner_id, :integer

    Announcement.reset_column_information
    
    Announcement.find_each do |announcement|
      announcement.owner_type = "Feed"
      announcement.owner_id = announcement.feed_id
      announcement.save!
    end

    remove_column :announcements, :feed_id
  end

  def self.down
    add_column :announcements, :feed_id
    
    Announcement.reset_column_information

    Announcement.find_each do |announcement|
      if announcement.feed_type != "Feed"
        raise "Announcement not belonging to a Feed not allowed"
      end
      announcement.feed_id = announcement.owner_id
      announcement.save!
    end

    remove_column :announcements, :owner_type
    remove_column :announcements, :owner_id
  end
end
