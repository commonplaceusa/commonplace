class AddManuallyAddedToResident < ActiveRecord::Migration
  def change
    add_column :residents, :manually_added, :boolean, :default => false
  end
end
