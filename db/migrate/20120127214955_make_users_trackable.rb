class MakeUsersTrackable < ActiveRecord::Migration
  def up
    change_table(:users) do |t|
      t.trackable
    end
  end

  def down
    remove_column :users, :trackable
  end
end
