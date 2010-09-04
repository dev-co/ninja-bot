class User
  include MongoMapper::Document

  key :_id, String

  key :channel_id, String, :index => true
  belongs_to :channel

  key :nick, String

  validates_uniqueness_of :nick, :scope => [:channel_id]
end
