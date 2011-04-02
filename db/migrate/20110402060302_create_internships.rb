class CreateInternships < ActiveRecord::Migration
  def self.up
    create_table :internships do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.string :college
      t.integer :graduation_year
      t.text :essay

      t.timestamps
    end
  end

  def self.down
    drop_table :internships
  end
end
