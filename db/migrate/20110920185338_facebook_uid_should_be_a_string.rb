class FacebookUidShouldBeAString < ActiveRecord::Migration
  def up
    change_column :users, :facebook_uid, :string
  end

  def down
    change_column :users, :facebook_uid, :integer
  end
end
