class CreateCivicLeaderApplications < ActiveRecord::Migration
  def change
    create_table :civic_leader_applications do |t|
      t.string :name
      t.string :email
      t.text :reason

      t.timestamps
    end
  end
end
