class AddLaunchDateToCommunities < ActiveRecord::Migration
  def self.up
    # January 1st 2010 was the beginning of time
    add_column :communities, :launch_date, :date, :default => Date.parse("2010-01-01") 
  end

  def self.down
    remove_column :communities, :launch_date
  end
end
