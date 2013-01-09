class AddRepliedAtToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :replied_at, :datetime
  end
end
