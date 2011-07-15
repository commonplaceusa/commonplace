
ShamRack.at("commonplace.api").rackup do 
  use(Rack::Cache,
      :verbose     => true,
      :metastore   => Dalli::Client.new,
      :entitystore => Dalli::Client.new)
  run API
end

