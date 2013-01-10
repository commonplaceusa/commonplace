class AddDeletedAtToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :deleted_at, :datetime
  end
end
