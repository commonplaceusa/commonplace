class RenameOrganizationsToGroups < ActiveRecord::Migration
  def self.up
    rename_table :organizations, :groups
  end

  def self.down
    rename_table :groups, :organizations
  end
end
