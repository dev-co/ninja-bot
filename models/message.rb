class Message
  include MongoMapper::Document

  key :_id, String
  key :user_id, String, :index => true, :required => true
  belongs_to :user

  key :type, String, :in => %w[normal quit part], :required => true
end