class Question
  include MongoMapper::Document

  key :_id, String
  key :language, String
  key :category, String
  key :text, String, :unique => true
  key :answer, String
end

