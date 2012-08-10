class CreateCivicHeroNominations < ActiveRecord::Migration
  def up
    unless CivicHeroNomination.table_exists?
      create_table :civic_hero_nominations do |t|
        t.string :nominee_name
        t.string :nominee_email
        t.text :reason
        t.string :nominator_name
        t.string :nominator_email
        t.integer :community_id

        t.timestamps
      end
    end
  end
  def down
    drop_table :civic_hero_nominations
  end
end
