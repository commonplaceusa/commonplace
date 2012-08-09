class AddLastExaminedStoryToResident < ActiveRecord::Migration
  def up
    add_column :residents, :last_examined_story, :integer
  end
  
  def down
    remove_column :residents, :last_examined_story
  end
end
