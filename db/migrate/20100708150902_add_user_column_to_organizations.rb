class AddUserColumnToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :user_id, :integer
  end

  def self.down
    remove_column :organizations, :user_id
  end
end
