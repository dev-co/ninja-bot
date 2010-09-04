class Channel
  include MongoMapper::Document

  key :_id, String
  has_many :users
end
