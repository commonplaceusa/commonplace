class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.integer :user_id, :null => false
      t.integer :organization_id, :null => false
      t.timestamps
    end
    remove_column :organizations, :user_id
  end

  def self.down
    drop_table :roles
    add_column :organizations, :user_id, :integer
  end
end
