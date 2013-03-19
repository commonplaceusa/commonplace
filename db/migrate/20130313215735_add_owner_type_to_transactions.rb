class AddOwnerTypeToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :owner_type, :string
    Transaction.all.each do |t|
      t.owner_type = "User"
    end
  end

  def self.down
    remove_column :transactions, :owner_type
  end
end
