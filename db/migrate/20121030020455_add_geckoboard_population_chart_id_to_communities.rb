class AddGeckoboardPopulationChartIdToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :geckoboard_population_chart_id, :string
  end
end
