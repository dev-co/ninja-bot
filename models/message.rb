class Message
  include MongoMapper::Document

  timestamps!

  key :_id, String
  key :user_id, String, :required => true
  belongs_to :user

  key :type, String, :in => %w[normal quit part], :required => true
  key :text, String
end
