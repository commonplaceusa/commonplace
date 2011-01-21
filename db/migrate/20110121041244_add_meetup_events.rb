class AddMeetupEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :type, :string
    add_column :events, :host_group_name, :string
  end

  def self.down
    remove_column :events, :type
    remove_column :events, :host_group_name
  end
end
