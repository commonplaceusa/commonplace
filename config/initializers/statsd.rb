if Rails.env.production?
  $statsd = Statsd.new(ENV['GRAPHITE_HOST'] || 'localhost', ENV['GRAPHITE_PORT'] || 8125)
  $statsd.namespace = "commonplace.#{Rails.env}"
end
