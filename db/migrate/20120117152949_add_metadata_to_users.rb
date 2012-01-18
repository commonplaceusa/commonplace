class AddMetadataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :metadata, :text
  end
end
