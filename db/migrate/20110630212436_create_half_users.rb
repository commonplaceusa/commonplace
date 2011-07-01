class CreateHalfUsers < ActiveRecord::Migration
  def self.up
    create_table :half_users do |t|
      t.string "first_name"
      t.string "last_name"
      t.string "password"
      t.string "street_address"
      t.string "email"
      t.string "single_access_token"
      t.timestamps
    end
  end

  def self.down
    drop_table :half_users
  end
end
