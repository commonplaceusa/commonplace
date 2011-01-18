class AddCommunityToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :community_id, :integer
    User.reset_column_information
    User.find_each do |user|
      user.community_id = Neighborhood.find(user.neighborhood_id).community_id
      user.save!
    end
  end

  def self.down
    remove_column :users, :community_id
  end
end
