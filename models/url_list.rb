class UrlList
  include Mongoid::Document
  include Mongoid::Timestamps

  identity :type => String

  field :user_id, :type => String
  belongs_to :user

  field :day, :type => String, :required => true, :index => true
  field :urls, :type => Array, :default => []
end
