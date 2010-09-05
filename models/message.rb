class Message
  include MongoMapper::Document

  timestamps!

  key :_id, String
  key :user_id, String, :required => true
  belongs_to :user

  key :type, String, :in => %w[normal command question badword quit part], :required => true
  key :text, String

  key :random, Float, :default => lambda { rand() }

  def self.random_message(conditions = {})
    r = rand()

    self.first(conditions.merge({:random.gte => r})) || self.first(conditions.merge({:random.lte => r}))
  end
end
