class CreateStory < ActiveRecord::Migration
  def up
    unless Story.table_exists?
      create_table :stories do |t|

        t.string :title
        t.integer :community_id
        t.text :url
        t.text :content
        t.text :summary
        t.timestamps
      end
    end
  end
  def down
    drop_table :stories
  end
end
