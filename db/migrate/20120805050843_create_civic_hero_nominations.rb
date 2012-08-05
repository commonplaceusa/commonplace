class CreateCivicHeroNominations < ActiveRecord::Migration
  def change
    create_table :civic_hero_nominations do |t|
      t.string :nominee_name
      t.string :nominee_email
      t.text :reason
      t.string :nominator_name
      t.string :nominator_email

      t.timestamps
    end
  end
end
