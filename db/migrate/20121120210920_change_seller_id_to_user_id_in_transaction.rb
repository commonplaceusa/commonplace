class ChangeSellerIdToUserIdInTransaction < ActiveRecord::Migration
  def change
    rename_column :transactions, :seller_id, :user_id
  end
end
