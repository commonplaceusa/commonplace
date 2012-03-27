class AddPublicFlagToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :public, :boolean

  end
end
