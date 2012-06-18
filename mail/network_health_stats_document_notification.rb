class NetworkHealthStatsDocumentNotification < MailBase
  def initialize(filename, interval)
    @filename = filename
    @interval = interval.to_s
  end

  def interval
    @interval
  end

  def document_url
    "http://www.ourcommonplace.com/internal/network_health_#{@interval}.xlsx"
  end

  def to
    "jberlinsky@gmail.com"
  end

end
