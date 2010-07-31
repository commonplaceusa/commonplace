class AddCurrentStatusColumnToAttendance < ActiveRecord::Migration
  def self.up
    add_column :attendances, :current_state, :string
  end

  def self.down
    remove_column :attendance, :current_state
  end
end
