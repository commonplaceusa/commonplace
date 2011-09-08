class ChangeEmailPostReceiveDefaultToLimitedLive < ActiveRecord::Migration
  def self.up
    change_column_default(:users, :post_receive_method, "Three")
  end

  def self.down
    change_column_default(:users, :post_receive_method, "Live")
  end
end
