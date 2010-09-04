class User
  include MongoMapper::Document

  key :_id, String

  key :channel_id, String, :index => true, :required => true
  belongs_to :channel

  key :nick, String, :required => true

  key :messages_count, Integer, :default => 0

  has_many :messages, :dependent => :destroy

  validates_uniqueness_of :nick, :scope => [:channel_id]
end
