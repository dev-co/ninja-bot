class UrlList
  include MongoMapper::Document

  key :_id, String

  key :user_id, String
  belongs_to :user

  key :day, String, :required => true
  key :urls, Array
end
