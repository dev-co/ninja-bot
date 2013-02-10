on :message do |message|
  @bot.localize!
  channel = message.channel
  irc_user = message.user

  if channel && irc_user
    @bot.history[channel.name] ||= FixedQueue.new(50)
    @bot.history[channel.name].add({:date => Time.zone.now, :text => message.message, :nick => irc_user.nick})

    user = Channel.get_user(channel.name, irc_user.nick)
    if message.events.detect { |event| event == :channel || event == :private }
      user.add_message(message.message)
    end
  elsif message.message =~ /^(\+1|\-1|next)\s*$/
    op = $1
    user = User.where(:nick => message.user.nick).first
    if user.current_message_id.present?
      case op
      when '-1'
        msg = Message.find(user.current_message_id)
        msg.vote_down!

        user.push(:reviewed => msg.id)
      when '+1'
        msg = Message.find(user.current_message_id)
        msg.vote_up!

        user.push(:reviewed => msg.id)
      when 'next'
        msg = nil
        if channel = Channel.where(:_id => user.reviewing).first
          msg = Message.random_message(:channel_id => channel.id, :_id.nin => user.reviewed)
          user.override(:current_message_id => msg.id, :reviewing => channel.id) if msg
        elsif target = User.where(:nick => user.reviewing).first
          msg = Message.random_message(:user_id => target.id, :_id.nin => user.reviewed)
          user.override(:current_message_id => msg.id, :reviewing => target.nick) if msg
        end

        message.user.send("#{msg.to_s} || type '+1' or '-1' to vote, 'next' to get a new message") if msg
      end
    end
  end
end

on :join do |message|
  Channel.get_user(message.channel.name, message.user.nick)
end

on :quit do |message|
  @bot.localize!
  User.override({:nick => message.user.nick.downcase}, {:last_seen_at => Time.zone.now.to_time, :last_quit_message => message.message})
end
