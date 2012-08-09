class AddAnnouncementCountToFeed < ActiveRecord::Migration
  def self.up
    add_column :feeds, :announcements_count, :integer, null:false, :default => 0
    Feed.find_each do |feed|
      num_announcements = execute("SELECT COUNT(id) FROM announcements WHERE owner_type = 'Feed' AND owner_id = #{feed.id}").values[0][0].to_i
      execute("UPDATE feeds SET announcements_count = #{num_announcements} WHERE id = #{feed.id}")
    end
  end
  def self.down
    remove_column :feeds, :announcements_count
  end
end
