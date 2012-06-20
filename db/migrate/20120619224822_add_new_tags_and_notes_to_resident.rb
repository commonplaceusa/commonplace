class AddNewTagsAndNotesToResident < ActiveRecord::Migration
  def change
    add_column :residents, :sector_tags, :text
    add_column :residents, :type_tags, :text
    add_column :residents, :notes, :string
  end
end
