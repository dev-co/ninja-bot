on :message, /.+/ do |message|
  channel = message.channel
  irc_user = message.user

  if channel && irc_user
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
