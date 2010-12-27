class CreateOutsideAnnouncements < ActiveRecord::Migration
  def self.up
    change_table :announcements do |t|
      t.string :type, :default => "Announcement"
      t.string :url
    end
  end

  def self.down
    #drop_table :outside_announcements
  end
end
