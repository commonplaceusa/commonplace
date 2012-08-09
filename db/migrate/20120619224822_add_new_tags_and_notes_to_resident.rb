class AddNewTagsAndNotesToResident < ActiveRecord::Migration
  def up
    begin
      add_column :residents, :sector_tags, :text
      add_column :residents, :type_tags, :text
      add_column :residents, :notes, :string
    rescue
    end
  end
  def down
    remove_column :residents, :sector_tags
    remove_column :residents, :type_tags
    remove_column :residents, :notes
  end
end
