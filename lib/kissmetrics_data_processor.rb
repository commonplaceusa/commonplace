class KissmetricsDataProcessor
  @queue = :statistics

  def self.perform
    # Download ALL the things.
    KissmetricsDumpDownload.perform
    # Import them
    require 'kmdb'


    # Restore the ActiveRecord connection
    ActiveRecord::Base.establish_connection
  end
end
