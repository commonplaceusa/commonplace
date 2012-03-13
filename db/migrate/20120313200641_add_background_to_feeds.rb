class AddBackgroundToFeeds < ActiveRecord::Migration
  def up
    add_column :feeds, :background_file_name, :string
    
    Feed.reset_column_information
  end
  
  def down
    remove_column :feeds, :background_file_name
  end
end
