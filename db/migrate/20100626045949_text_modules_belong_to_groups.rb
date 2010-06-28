class TextModulesBelongToGroups < ActiveRecord::Migration
  def self.up
    rename_column :text_modules, :organization_id, :group_id
  end

  def self.down
    rename_column :text_modules, :group_id, :organization_id
  end
end
