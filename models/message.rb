class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  include MongoidExt::Random

  field :_id, type: String

  field :user_id, :type => String
  belongs_to :user
  
  field :channel_id, :type => String
  belongs_to :channel
  
  field :created_by_id, :type => String
  belongs_to :created_by, :class_name => "User"

  field :type, :type => String
  field :text, :type => String
  
  field :votes_up, :type => Integer, :default => 0
  field :votes_down, :type => Integer, :default => 0
  field :votes_total, :type => Integer, :default => 0

  validates_presence_of :user
  validates_presence_of :type


  def self.random_message(conditions = {})
    self.random conditions
  end

  def to_s
    date = Time.zone ? self.created_at.in_time_zone : self.created_at
    "[#{date}] <#{self.user.nick}> #{self.text}"
  end
  
  def vote_up!
    self.increment(:votes_up => 1, :votes_total => 1)
  end
  
  def vote_down!
    self.increment(:votes_down => 1, :votes_total => -1)
  end
  
  def should_be_deleted?
    self.votes_total <= 3
  end
end
