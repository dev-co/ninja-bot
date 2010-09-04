class User
  include MongoMapper::Document

  key :_id, String

  key :channel_id, String
  belongs_to :channel

  key :nick, String

end