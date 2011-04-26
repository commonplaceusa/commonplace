class AddReceiveMethodToMemberships < ActiveRecord::Migration
  def self.up
    add_column :memberships, :receive_method, :string, :default => "Daily"

    Membership.reset_column_information

    Membership.find_each do |membership|
      membership.receive_method = "Daily"
      membership.save!
    end

  end

  def self.down
    remove_column :memberships, :receive_method
  end
end
