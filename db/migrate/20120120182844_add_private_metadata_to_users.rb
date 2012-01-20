class AddPrivateMetadataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :private_metadata, :text
  end
end

