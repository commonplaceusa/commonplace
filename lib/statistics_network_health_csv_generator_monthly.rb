class StatisticsNetworkHealthCsvGeneratorMonthly < StatisticsNetworkHealthCsvGenerator
  def self.start_date
    (end_date - days_elapsed.days).to_datetime
  end

  def self.days_elapsed
    30
  end

  def self.filename
    "network_health_monthly.xlsx"
  end
end
