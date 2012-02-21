MongoMapper.connection = Mongo::Connection.new(ENV['MONGOHQ_URL'] || 'localhost')
MongoMapper.database = "commonplace_stats_#{Rails.env}"
