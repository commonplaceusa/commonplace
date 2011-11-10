class AddDiscountBusinessesToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :discount_businesses, :text
  end
end
