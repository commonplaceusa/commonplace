class CreateRssFeeds < ActiveRecord::Migration
  def self.up
    change_table :feeds do |t|
      t.string :type, :default => "Feed"
      t.string :feed_url
    end
  end

  def self.down
    remove_column :feeds, :type
    remove_column :feeds, :feed_url
  end
end
