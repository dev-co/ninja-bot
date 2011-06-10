class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  include MongoidExt::Random

  identity :type => String
  field :language, :type => String
  field :category, :type => String
  field :text, :type => String, :unique => true
  field :answer, :type => String

  field :asked_times, :type => Integer, :default => 0

  def self.random_question(conditions = {})
    self.random
  end
end

