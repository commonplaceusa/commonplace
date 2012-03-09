class AddMetadataColumnToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :metadata, :text
  end
end
