class CreateOrganizerDataPoints < ActiveRecord::Migration
  def self.up
    create_table :organizer_data_points do |t|
      t.integer :organizer_id
      t.string :address
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :organizer_data_points
  end
end
