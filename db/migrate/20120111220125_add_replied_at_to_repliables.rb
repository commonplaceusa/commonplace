class AddRepliedAtToRepliables < ActiveRecord::Migration
  def change
    [:posts, :events, :announcements, :group_posts, :messages].each do |t|
      add_column t, :replied_at, :datetime
    end
  end
end
