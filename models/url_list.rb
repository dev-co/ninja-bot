class UrlList
  include Mongoid::Document
  include Mongoid::Timestamps

  field :day, :type => String
  field :urls, :type => Array, :default => []

  belongs_to :user

  validates_presence_of :day
  index({ :day => 1 })
end
