class AddZipcodeToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :zip_code, :string
  end

  def self.down
    remove_column :communities, :zip_code
  end
end
