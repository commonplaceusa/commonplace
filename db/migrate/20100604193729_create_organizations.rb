class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name, :null => false
      t.string :location
      t.string  "avatar_file_name"
      t.string  "avatar_content_type"
      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
