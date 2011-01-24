class MakePostAreaPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :posts, :neighborhood_id, :area_id
    add_column :posts, :area_type, :string
    
    Post.reset_column_information
    
    Post.find_each do |post|
      post.area_type = "Neighborhood"
      post.save!
    end
  end

  def self.down
    Post.find_each do |post|
      if !post.area.is_a? Neigbhorhood
        raise "Post has an area that is not a Neigbhorhood"
      end
    end
  end
end
