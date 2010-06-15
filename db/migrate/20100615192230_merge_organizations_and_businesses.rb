class MergeOrganizationsAndBusinesses < ActiveRecord::Migration
  def self.up
    drop_table :businesses
    
    add_column :organizations, :type, :string, :null => false, :default => "Organization"
    add_column :organizations, :lat, :decimal, :precision => 15, :scale => 10
    add_column :organizations, :lng, :decimal, :precision => 15, :scale => 10
    add_column :organizations, :about, :text
    rename_column :organizations, :location, :address
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
