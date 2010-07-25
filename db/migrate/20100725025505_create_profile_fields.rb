class CreateProfileFields < ActiveRecord::Migration
  def self.up
    create_table :profile_fields do |t|
      t.string :subject, :null => false
      t.string :body, :null => false
      t.integer :organization_id, :null => false
      t.integer :position, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :profile_fields
  end
end
