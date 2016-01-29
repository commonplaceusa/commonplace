MongoMapper.config = {
  Rails.env => {
    'uri' => ENV['MONGOLAB_URI'] || 'mongodb://localhost/commonplace_stats'
  }
}

MongoMapper.connect(Rails.env)
