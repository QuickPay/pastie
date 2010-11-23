MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => logger)

case Padrino.env
  when :development then MongoMapper.database = 'scruffy_development'
  when :production  then MongoMapper.database = 'scruffy'
  when :test        then MongoMapper.database = 'scruffy_test'
end
