class AddSourceFeedIdToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :source_feed_id, :string
  end

  def self.down
    remove_column :events, :source_feed_id
  end
end