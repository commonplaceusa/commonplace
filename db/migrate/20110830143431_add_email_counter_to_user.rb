class AddEmailCounterToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :emails_sent, :integer, :default => 0
  end

  def self.down
    remove_column :users, :emails_sent
  end
end
