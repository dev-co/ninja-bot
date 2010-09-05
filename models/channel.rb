class Channel
  include MongoMapper::Document

  key :_id, String
  has_many :users

  def self.get_user(name, nick)
    channel = Channel.find(name)
    channel = Channel.create(:_id => name) if channel.nil?

    user = channel.users.first(:nick => nick)
    user = channel.users.create(:nick => nick) if user.nil?

    user
  end
end
