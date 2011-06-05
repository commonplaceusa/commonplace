class AddSeenTourFlagToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :seen_tour, :boolean

    User.reset_column_information
    
    User.find_each do |user|
      # if the user has posted, seen_tour is true

      user.toggle!(:seen_tour) if [user.posts, user.events, 
                                   user.announcements, user.group_posts, 
                                   user.replies].any?(&:any?)
    end
          
  end

  def self.down
    remove_column :users, :seen_tour
  end
end
