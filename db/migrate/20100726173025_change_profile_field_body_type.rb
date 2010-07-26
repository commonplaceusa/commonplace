class ChangeProfileFieldBodyType < ActiveRecord::Migration
  def self.up
    change_column(:profile_fields, :body, :text)
  end

  def self.down
    change_column(:profile_fields, :body, :string)
  end
end
