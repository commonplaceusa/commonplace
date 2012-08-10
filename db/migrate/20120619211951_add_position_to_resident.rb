class AddPositionToResident < ActiveRecord::Migration
  def self.up
    add_column :residents, :position, :string
  end
  def self.down
    remove_column :residents, :position
  end
end
