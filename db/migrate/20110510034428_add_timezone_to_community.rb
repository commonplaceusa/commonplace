class AddTimezoneToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :time_zone, :string, :default => "Eastern Time (US & Canada)"

    Community.reset_column_information

    Community.find_each do |community|
      community.time_zone = "Eastern Time (US & Canada)"
      community.save!
    end
  end

  def self.down
    remove_column :communities, :time_zone
  end
end
