class AddNewsToFeed < ActiveRecord::Migration
  def self.up
    add_column :feeds, :is_news, :boolean
  end

  def self.down
    remove_column :feeds, :is_news
  end
end
