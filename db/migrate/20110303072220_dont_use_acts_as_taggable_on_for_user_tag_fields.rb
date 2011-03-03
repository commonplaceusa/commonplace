class DontUseActsAsTaggableOnForUserTagFields < ActiveRecord::Migration
  def self.up
    rename_column :users, :cached_interest_list, :interest_list

    rename_column :users, :cached_good_list, :offer_list
    remove_column :users, :cached_skill_list
  end

  def self.down
    rename_column :users, :interest_list, :cached_interest_list

    rename_column :users, :offer_list, :cached_good_list
    add_column :users, :cached_skill_list, :string
  end
end
