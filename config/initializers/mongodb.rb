MongoMapper.config = {
  Rails.env => {
    'uri' => ENV['MONGOLAB_URI'] || 'mongodb://localhost/commonplace_stats'
  }
}

if Rails.env.production?
  MongoMapper.connect(Rails.env)
else
  MongoMapper.connection = EmbeddedMongo::Connection.new
  MongoMapper.database = 'commonplace_embeddable'
end
