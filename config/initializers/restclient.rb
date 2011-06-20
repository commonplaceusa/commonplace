require 'restclient/components'
RestClient.enable(Rack::Cache,
                  :metastore => "file:#{Rails.root.join("tmp/cache/rack/meta")}",
                  :entitystore => "file:#{Rails.root.join("tmp/cache/rack/body")}",
                  :verbose     => true)

