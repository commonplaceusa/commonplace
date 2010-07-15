class AddPurposeColumnToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :purpose, :string, :null => false, :default => "tell" 
    change_column :posts, :purpose, :string, :null => false
  end

  def self.down
    remove_column :posts, :purpose
  end
end
