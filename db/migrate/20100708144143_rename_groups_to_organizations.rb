class RenameGroupsToOrganizations < ActiveRecord::Migration
  def self.up
    rename_table :groups, :organizations
    remove_column :organizations, :type
  end

  def self.down
    rename_table :organizations, :groups
    add_column :groups, :type, :string
  end
end
