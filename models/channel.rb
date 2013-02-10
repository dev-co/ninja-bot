class Channel
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  has_many :users
  has_many :logs

  index({:name => 1}, {:unique => true})

  def self.get_user(name, nick, create = true)
    name = name.downcase
    nick = nick.downcase
    channel = Channel.find_or_create_by(name: name)

    user = channel.users.where(:nick => nick).first
    user = channel.users.create!(:nick => nick) if user.nil? && create

    user
  end

  def self.add_log_message(name, message)
    channel = Channel.find_or_create_by(:name => name)

    log = Log.where(:channel_id => channel.id).desc(:created_at).only(%w[messages_count channel_id]).first
    if log.nil? || log.messages_count >= 100
      log = Log.create(:channel_id => channel.id)
    end
    Log.collection.find({:_id => log.id}).update({ :$push => { :messages => message},
                                            :$inc => {:messages_count => 1} })
  end
end

