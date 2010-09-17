class UrlList
  include MongoMapper::Document
  timestamps!

  key :_id, String

  key :user_id, String
  belongs_to :user

  key :day, String, :required => true, :index => true
  key :urls, Array
end
