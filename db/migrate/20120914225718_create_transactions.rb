class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :title
      t.text :description
      t.string :item_file_name
      t.text :metadata
      t.integer :community_id
      t.integer :buyer_id
      t.integer :seller_id, :null => false
      t.integer :price_in_cents, :default => 0
      t.integer :buyer_fee, :default => 0
      t.integer :seller_fee, :default => 0
      t.boolean :pending, :default => false
      t.boolean :confirmed, :default => false

      t.timestamps
    end
  end
end
