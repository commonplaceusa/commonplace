class CreateRssFeeds < ActiveRecord::Migration
  def self.up
    change_table :feeds do |t|
      t.string :type, :default => "Feed"
      t.string :feed_url
    end
  end

  def self.down
  end
end
