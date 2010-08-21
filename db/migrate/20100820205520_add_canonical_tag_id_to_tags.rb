class AddCanonicalTagIdToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :canonical_tag_id, :integer
  end

  def self.down
    remove_column :tags, :canonical_tag_id
  end
end
