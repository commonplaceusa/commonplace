$KissmetricsAPIToken = ENV['KISSMETRICS_API_TOKEN'] || "disabled"

require 'km'

KM.init($KissmetricsAPIToken)
