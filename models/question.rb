class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  include MongoidExt::Random

  field :language, :type => String
  field :category, :type => String
  field :text, :type => String
  field :answer, :type => String

  field :asked_times, :type => Integer, :default => 0  

  validates_presence_of :text

  def self.random_question(conditions = {})
    self.random
  end
end

