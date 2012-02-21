if ENV['MONGOHQ_HOST']
  MongoMapper.connection = Mongo::Connection.new(ENV['MONGOHQ_HOST'], ENV['MONGOHQ_PORT'])
  MongoMapper.database = ENV['MONGOHQ_DATABASE']
  MongoMapper.database.authenticate(ENV['MONGOHQ_USERNAME'], ENV['MONGOHQ_PASSWORD'])
else
  puts "Please make sure that you have MongoDB installed and running locally"
  puts "Otherwise, bad things will happen."
  MongoMapper.connection = Mongo::Connection.new('localhost')
  MongoMapper.database = "commonplace_stats_#{Rails.env}"
end
