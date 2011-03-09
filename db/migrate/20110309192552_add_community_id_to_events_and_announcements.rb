class AddCommunityIdToEventsAndAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :events, :community_id, :integer
    add_column :announcements, :community_id, :integer

    Event.reset_column_information
    Announcement.reset_column_information
    
    Event.find_each do |event|
      event.community_id = event.owner.community_id
      event.save!
    end

    Announcement.find_each do |announcement| 
      announcement.community_id = announcement.owner.community_id
      announcement.save!
    end
      
  end

  def self.down
    remove_column :events, :community_id
    remove_column :announcements, :community_id
  end
end
