class Question
  include MongoMapper::Document

  key :_id, String
  key :language, String
  key :category, String
  key :text, String, :unique => true
  key :answer, String

  key :asked_times, Integer, :default => 0
  key :random, Float, :default => lambda {rand()}
  
  def self.random_question(conditions = {})
    r = rand()
    conditions[:sort] = "asked_times asc"
    Question.first(conditions.merge(:random.gte => r)) || Question.first(conditions.merge(:random.lte => r))
  end
end

