class CreateAvatars < ActiveRecord::Migration
  def self.up
    create_table :avatars do |t|
      t.integer :owner_id
      t.string :owner_type
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :avatars
  end
end
