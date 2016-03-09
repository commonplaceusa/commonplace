MongoMapper.config = {
  Rails.env => {
    'uri' => ENV['MONGOLAB_URI'] || "mongodb://#{ENV["MONGO_PORT_27017_TCP_ADDR"]}/commonplace_stats"
  }
}

MongoMapper.connect(Rails.env)
