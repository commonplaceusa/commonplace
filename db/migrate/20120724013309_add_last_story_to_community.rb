class AddLastStoryToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :last_story, :text
  end

  def down
    remove_column :communities, :last_story
  end
end
