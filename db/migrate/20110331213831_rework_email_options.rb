class ReworkEmailOptions < ActiveRecord::Migration
  def self.up
    add_column :users, :post_receive_method, :string
    
    User.reset_column_information
    
    User.find_each do |user|
      user.post_receive_method = 
        if user.receive_digests
          user.post_receive_method = "Daily"
        elsif user.receive_posts
          user.post_receive_method = "Live"
        else
          "Never"
        end
      user.save!
    end

    remove_column :users, :receive_digests
    remove_column :users, :receive_posts
  end

  def self.down
    add_column :users, :receive_digest, :boolean
    add_column :users, :receive_posts, :boolean

    User.reset_column_information
    
    User.find_each do |user|
      user.receive_digests = 
        user.post_receive_method == "Daily"
      user.receive_posts = user.post_receive_method == "Live"
      user.save!
    end

    remove_column :users, :post_receive_method
  end
end
