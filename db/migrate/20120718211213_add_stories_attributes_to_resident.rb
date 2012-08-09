class AddStoriesAttributesToResident < ActiveRecord::Migration
  def up
    add_column :residents, :stories_count, :integer, null:false, :default => 0
    add_column :residents, :last_story_time, :datetime
    add_column :residents, :old_stories, :text
  end

  def down
    remove_column :residents, :stories_count
    remove_column :residents, :last_story_time
    remove_column :residents, :old_stories
  end
end
