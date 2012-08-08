class AddTagTypesToResident < ActiveRecord::Migration
  def up
    add_column :residents, :input_method, :string
    add_column :residents, :PFO_status, :string
    add_column :residents, :organizer, :string
  end

  def down
    remove_column :residents, :input_method
    remove_column :residents, :PFO_status
    remove_column :residents, :organizer
  end
end
