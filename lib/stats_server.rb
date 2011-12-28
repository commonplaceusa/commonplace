require "fnordmetric"

FnordMetric.namespace :commonplace do

  gauge :pageviews_daily_unique, :tick => 1.day.to_i, :unique => true, :title => "Unique Visits (Daily)"
  gauge :pageviews_hourly_unique, :tick => 1.hour.to_i, :unique => true, :title => "Unique Visits (Hourly)"
  gauge :pageviews_monthly_unique, :tick => 40.days.to_i, :unique => true, :title => "Unique Visits (Month)"

  gauge :pageviews_per_url_daily, 
    :tick => 1.day.to_i, 
    :title => "Daily Pageviews per URL",
    :three_dimensional => true

  gauge :pageviews_per_url_monthly,
    :tick => 30.days.to_i,
    :title => "Monthly Pageviews per URL", 
    :three_dimensional => true

  event :_pageview do
    incr :pageviews_daily_unique
    incr :pageviews_hourly_unique
    incr :pageviews_monthly_unique
    incr_field :pageviews_per_url_daily, data[:url]
    incr_field :pageviews_per_url_monthly, data[:url]
  end

  widget 'Overview', { 
    :title => "Unique Visits per Day",
    :type => :timeline,
    :width => 67,
    :gauges => :pageviews_daily_unique,
    :include_current => true,
    :autoupdate => 30
  }
  
  widget 'Overview', { 
    :title => "Unique Visits per Hour",
    :type => :timeline,
    :width => 33,
    :gauges => :pageviews_hourly_unique,
    :include_current => true,
    :autoupdate => 30
  }

  #widget 'Overview', { 
  #  :title => "CP Key Metrics",
  #  :type => :numbers,
  #  :width => 100,
  #  :autoupdate => 30,
  #  :gauges => []
  #}

  #widget 'Overview', { 
  #  :title => "User Activity",
  #  :type => :timeline,
  #  :width => 67,
  #  :autoupdate => 30,
  #  :gauges => []
  #}

  widget 'Overview', { 
    :title => "Top Pages",
    :type => :toplist,
    :autoupdate => 30,
    :width => 33,
    :gauges => [ :pageviews_per_url_daily, :pageviews_per_url_monthly ]
  }

  #widget 'Overview', { 
  #  :title => "CP User Metrics",
  #  :type => :numbers,
  #  :width => 67,
  #  :autoupdate => 30,
  #  :gauges => []
  #}

  # User Activity

 

end

FnordMetric.run(:web_interface => ["0.0.0.0", 4242])
