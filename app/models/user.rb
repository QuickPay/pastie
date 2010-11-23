class User
  include MongoMapper::Document

  # key <name>, <type>
  key :email, String
  key :password, String
  key :name, String
  key :token, String
  timestamps!
end
