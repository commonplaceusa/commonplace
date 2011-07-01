class AddMiddleNameToHalfUsers < ActiveRecord::Migration
  def self.up
    add_column :half_users, :middle_name, :string
  end

  def self.down
    remove_column :half_users, :middle_name
  end
end
