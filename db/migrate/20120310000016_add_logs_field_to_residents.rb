class AddLogsFieldToResidents < ActiveRecord::Migration
  def change
    add_column :residents, :logs, :text
  end
end
