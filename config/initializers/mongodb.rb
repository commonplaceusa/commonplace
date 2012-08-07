MongoMapper.config = {
  Rails.env => {
    'uri' => ENV['MONGOLAB_URI'] || 'mongodb://localhost/commonplace_stats'
  }
}

#if Rails.env.production? || ENV['MONGOLAB_URI']
  MongoMapper.connect(Rails.env)
=begin
else
  MongoMapper.connection = EmbeddedMongo::Connection.new
  MongoMapper.database = 'commonplace_embeddable'
end
=end
