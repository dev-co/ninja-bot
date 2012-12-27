class Channel
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, type: String
  has_many :users
  has_many :logs

  def self.get_user(name, nick, create = true)
    name = name.downcase
    nick = nick.downcase

    channel = Channel.find_or_create_by(:_id => name)

    user = channel.users.where(:nick => nick).first
    user = channel.users.create(:nick => nick) if user.nil? && create

    user
  end

  def self.add_log_message(name, message)
    channel = Channel.find_or_create_by(:_id => name)

    log = Log.where(:channel_id => channel.id, :order => "created_at desc").only(%w[messages_count channel_id]).first
    if log.nil? || log.messages_count >= 100
      log = Log.create(:channel_id => channel.id)
    end

    Log.push({:_id => log.id}, {:messages => message})
    Log.increment({:_id => log.id},{:messages_count => 1})
  end
end

