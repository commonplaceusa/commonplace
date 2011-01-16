class AddTwitterNameToFeed < ActiveRecord::Migration
  def self.up
    add_column :feeds, :twitter_name, :string
  end

  def self.down
    remove_column :feeds, :twitter_name
  end
end
