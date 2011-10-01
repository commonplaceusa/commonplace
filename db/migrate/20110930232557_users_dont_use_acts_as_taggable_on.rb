class UsersDontUseActsAsTaggableOn < ActiveRecord::Migration
  def up
    say_with_time("Changing skill_list to text and renaming to skills") do
      change_column :users, :cached_skill_list, :text
      rename_column :users, :cached_skill_list, :skills
    end
    
    say_with_time("Changing good_list to text and renaming to goods") do
      change_column :users, :cached_good_list, :text
      rename_column :users, :cached_good_list, :goods
    end

    say_with_time("Changing interest_list to text and renaming to interests") do
      change_column :users, :cached_interest_list, :text
      rename_column :users, :cached_interest_list, :interests
    end
  end

  def down
    say_with_time("Changing skills to string and renaming to skill_list") do
      change_column :users, :skills, :text
      rename_column :users, :skills, :cached_skill_list
    end
    
    say_with_time("Changing goods to string and renaming to good_list") do
      change_column :users, :goods, :sting
      rename_column :users, :goods, :cached_good_list
    end

    say_with_time("Changing interests to text and renaming to interest_list") do
      change_column :users, :interests, :text
      rename_column :users, :interests, :cached_interest_list
    end
  end
end
