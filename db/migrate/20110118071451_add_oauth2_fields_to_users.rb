class AddOauth2FieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :oauth2_token, :string
    add_index :users, :oauth2_token
    change_column :users, :persistence_token, :string, :null => true
  end

  def self.down
    remove_column :users, :oauth2_token
  end
end
