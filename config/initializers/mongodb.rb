MongoMapper.config = {
  Rails.env => {
    'uri' => ENV['MONGOHQ_URL'] || 'mongodb://localhost/commonplace_stats'
  }
}

MongoMapper.connect(Rails.env)
