class RemoveAttendingFromAttendances < ActiveRecord::Migration
  def self.up
    remove_column :attendances, :attending
  end

  def self.down
    add_column :attendances, :attending, :boolean
  end
end
