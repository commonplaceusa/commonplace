class AddOrganizationColumnToEventsAndTextModules < ActiveRecord::Migration
  def self.up
    rename_column :text_modules, :group_id, :organization_id
    add_column :events, :organization_id, :integer
  end

  def self.down
    rename_column :text_modules, :organization_id, :group_id
    remove_column :events, :organization_id
  end
end
