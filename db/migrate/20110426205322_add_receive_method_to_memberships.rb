class AddReceiveMethodToMemberships < ActiveRecord::Migration
  def self.up
    add_column :memberships, :receive_method, :string, :default => "Live"

    Membership.reset_column_information

    Membership.find_each do |membership|
      membership.receive_method = "Live"
      membership.save!
    end

  end

  def self.down
    remove_column :memberships, :receive_method
  end
end
