class AddCachedTagsColumnsToTaggables < ActiveRecord::Migration
  def self.up
    add_column :users, :cached_skill_list, :string
    add_column :users, :cached_interest_list, :string
    add_column :users, :cached_good_list, :string

    User.reset_column_information
    User.all.each do |u|
      u.cached_skill_list = u.skill_list.join(",")
      u.cached_interest_list = u.interest_list.join(",")
      u.cached_good_list = u.good_list.join(",")
      u.save
    end

    add_column :events, :cached_tag_list, :string
    add_column :organizations, :cached_tag_list, :string
  end

  def self.down
    remove_column :users, :cached_skill_list
    remove_column :users, :cached_interest_list
    remove_column :users, :cached_good_list

    remove_column :events, :cached_tag_list
    remove_column :organizations, :cached_tag_list
  end
end
