class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  include MongoidExt::Random

  identity :type => String
  field :user_id, :type => String, :required => true
  belongs_to :user

  field :type, :type => String, :required => true
  field :text, :type => String


  def self.random_message(conditions = {})
    self.random
  end

  def to_s
    date = Time.zone ? self.created_at.in_time_zone : self.created_at
    "[#{date}] <#{self.user.nick}> #{self.text}"
  end
end
