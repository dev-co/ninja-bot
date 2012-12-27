class UrlList
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, :type => String

  field :user_id, :type => String
  belongs_to :user

  field :day, :type => String
  field :urls, :type => Array, :default => []

  validates_presence_of :day
  index({ :day => 1 })
end
