class AddTweetIdToAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :announcements, :tweet_id, :string
  end

  def self.down
    remove_column :announcements, :tweet_id
  end
end
