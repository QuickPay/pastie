class Paste
  include MongoMapper::Document

  # key <name>, <type>
  key :title, String
  key :paste, String
  key :type, String
  timestamps!
end
