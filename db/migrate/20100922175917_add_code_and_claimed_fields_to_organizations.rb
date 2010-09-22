class AddCodeAndClaimedFieldsToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :code, :string
    add_column :organizations, :claimed, :boolean, :default => true
  end

  def self.down
    remove_column :organizations, :code
    remove_column :organizations, :claimed
  end
end
