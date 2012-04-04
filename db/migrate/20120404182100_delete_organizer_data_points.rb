class DeleteOrganizerDataPoints < ActiveRecord::Migration
  def up
    drop_table :organizer_data_points
  end

  def down
  end
end
