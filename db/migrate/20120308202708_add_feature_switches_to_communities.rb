class AddFeatureSwitchesToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :feature_switches, :text
  end
end
