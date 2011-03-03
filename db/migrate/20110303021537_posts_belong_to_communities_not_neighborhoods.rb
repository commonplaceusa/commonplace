class PostsBelongToCommunitiesNotNeighborhoods < ActiveRecord::Migration
  def self.up
    add_column :posts, :community_id, :integer

    Post.reset_column_information

    Post.find_each do |post|
      case post.area_type
      when "Neighborhood"
        post.community_id = Neighborhood.find(post.area_id).community_id
      when "Community"
        post.community_id = post.area_id
      else
        raise "Unknown area_type"
      end
      
      post.save!
    end

    remove_column :posts, :area_id
    remove_column :posts, :area_type
  end

  def self.down
    add_column :posts, :area_id, :integer
    add_column :posts, :area_type, :string
    
    Post.reset_column_information

    Post.find_each do |post|
      post.area_type = "Neighborhood"
      post.area_id = post.user.neighborhood.id
      post.save!
    end
    
    remove_column :posts, :community_id
  end
end
