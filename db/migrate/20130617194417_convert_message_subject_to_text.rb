class ConvertMessageSubjectToText < ActiveRecord::Migration
  def up
    change_column :messages, :subject, :text
  end

  def down
    change_column :messages, :subject, :string
  end
end
