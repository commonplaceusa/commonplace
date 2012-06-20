class AddPositionToResident < ActiveRecord::Migration
  def change
    add_column :residents, :position, :string
  end
end
