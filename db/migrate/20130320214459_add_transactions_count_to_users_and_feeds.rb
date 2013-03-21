class AddTransactionsCountToUsersAndFeeds < ActiveRecord::Migration
  def change
    add_column :users, :transactions_count, :integer, default: 0
    add_column :feeds, :transactions_count, :integer, default: 0
  end
end
