class AddCalculatedCpCreditsAndValidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :calculated_cp_credits, :integer
    add_column :users, :cp_credits_are_valid, :boolean, :default => false
  end
end
