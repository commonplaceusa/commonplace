class AddReferralSourceToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :referral_source, :string
  end

  def self.down
    remove_column :users, :referral_source
  end
end
