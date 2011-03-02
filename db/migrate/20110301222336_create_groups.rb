class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.string :slug
      t.string :about
      t.integer :community_id
      t.string :avatar_file_name
      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
