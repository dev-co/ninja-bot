on :message, /.+/ do |message|
  @bot.localize!
  channel = message.channel
  irc_user = message.user

  @history ||= {}

  if channel && irc_user
    @history[channel.name] ||= FixedQueue.new(20)
    @history[channel.name].add("[#{Time.zone.now}] <#{irc_user}> #{message.message}")

    user = Channel.get_user(channel.name, irc_user.nick)
    case message.events
    when [:channel, :message]
      user.add_message(message.message)
    when [:private, :message]
      user.add_message(message.message)
    when [:ctcp, :private, :message]
    when [:ctcp, :channel, :message]
    end
  end
end

on :join do |message|
  Channel.get_user(message.channel.name, message.user.nick)
end

on :quit do |message|
  @bot.localize!
  User.set({:nick => message.user.nick.downcase}, {:last_seen_at => Time.zone.now, :last_quit_message => message.message})
end