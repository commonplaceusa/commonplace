class RenameLocationToAddressOnEvents < ActiveRecord::Migration
  def self.up
    rename_column :events, :location, :address
  end

  def self.down
    rename_column :events, :address, :location
  end
end
