class SetDefaultPostReceiveMethod < ActiveRecord::Migration
  def self.up
    change_column :users, :post_receive_method, :string, :default => "Live"
  end

  def self.down
    change_column :users, :post_receive_method, :string, :default => "Daily"
  end
end
