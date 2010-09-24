class Message
  include MongoMapper::Document

  timestamps!

  key :_id, String
  key :user_id, String, :required => true
  belongs_to :user

  key :type, String, :required => true
  key :text, String

  key :random, Float, :default => lambda { rand() }

  def self.random_message(conditions = {})
    r = rand()

    conditions[:sort] = "random asc"
    self.first(conditions.merge({:random.gte => r})) || self.first(conditions.merge({:random.lte => r}))
  end

  def to_s
    "[#{self.created_at}] <#{self.user.nick}> #{self.text}"
  end
end
