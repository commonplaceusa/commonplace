class RemovesUnusedColumnUsersSeenTour < ActiveRecord::Migration
  def up
    remove_column :users, :seen_tour
  end

  def down
    add_column :users, :seen_tour, :boolean
  end
end
