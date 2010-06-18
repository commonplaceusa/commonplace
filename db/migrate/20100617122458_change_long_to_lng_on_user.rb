class ChangeLongToLngOnUser < ActiveRecord::Migration
  def self.up
    rename_column :users, :long, :lng
  end

  def self.down
    rename_column :users, :lng, :long
  end
end
