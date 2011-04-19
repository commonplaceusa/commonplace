class AddReceiveMethodToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :receive_method, :string, :default => "Daily"
    
    Subscription.reset_column_information
    
    Subscription.find_each do |s|
      s.receive_method = "Daily"
      s.save!
    end
      
  end

  def self.down
    remove_column :subscriptions, :receive_method
  end
end
