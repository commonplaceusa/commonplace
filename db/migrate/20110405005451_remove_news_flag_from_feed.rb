class RemoveNewsFlagFromFeed < ActiveRecord::Migration
  def self.up
    remove_column :feeds, :is_news
  end

  def self.down
    add_column :feeds, :is_news, :boolean
  end
end
