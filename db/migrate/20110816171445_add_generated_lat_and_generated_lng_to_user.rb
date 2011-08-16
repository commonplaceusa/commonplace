class AddGeneratedLatAndGeneratedLngToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :generated_lat, :float
    add_column :users, :generated_lng, :float
  end

  def self.down
    remove_column :users, :generated_lng
    remove_column :users, :generated_lat
  end
end
