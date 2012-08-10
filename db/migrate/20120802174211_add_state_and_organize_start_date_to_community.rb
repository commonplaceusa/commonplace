class AddStateAndOrganizeStartDateToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :state, :string
    add_column :communities, :organize_start_date, :date
  end
  def self.down
    remove_column :communities, :state
    remove_column :communities, :organize_start_date
  end
end
