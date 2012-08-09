class AddPositionToResident < ActiveRecord::Migration
  def self.up
    begin
      add_column :residents, :position, :string
    rescue
    end
  end
  def self.down
    remove_column :residents, :position
  end
end
