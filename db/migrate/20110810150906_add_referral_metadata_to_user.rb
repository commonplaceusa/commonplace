class AddReferralMetadataToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :referral_metadata, :string
  end

  def self.down
    remove_column :users, :referral_metadata
  end
end
