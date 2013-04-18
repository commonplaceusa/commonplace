class AddOwnerTypeToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :owner_type, :string

    unless column_exists? :transactions, :owner_id
      rename_column :transactions, :user_id, :owner_id
    end
    Transaction.all.each do |t|
      t.owner_type = "User"
    end
  end

  def self.down
    remove_column :transactions, :owner_type
    rename_column :transactions, :owner_id, :user_id
  end
end
