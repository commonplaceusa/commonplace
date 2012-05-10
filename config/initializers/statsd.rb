if Rails.env.production?
  $statsd = Statsd.new(ENV['GRAPHITE_HOST'] || '107.20.208.98', ENV['GRAPHITE_PORT'] || 8125)
  $statsd.namespace = "commonplace.#{Rails.env}"
end
