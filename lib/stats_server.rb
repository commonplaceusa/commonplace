require "fnordmetric"

FnordMetric.namespace :commonplace do
  gauge :users_signing_in_per_hour,
    :tick => 1.hour.to_i,
    :title => "Users signing in per Hour"

  event(:user_signed_in) do
    incr :users_signing_in_per_hour
  end

  widget 'Overview', {
    :title => "Users Signing In Per Hour",
    :type => :timeline,
    :gauges => :users_signing_in_per_hour,
    :autoupdate => 1
  }

end

FnordMetric.standalone
