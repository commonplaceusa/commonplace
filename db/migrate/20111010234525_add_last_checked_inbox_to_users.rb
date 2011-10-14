class AddLastCheckedInboxToUsers < ActiveRecord::Migration
  def change

    add_column :users, :last_checked_inbox, :datetime

  end
end
