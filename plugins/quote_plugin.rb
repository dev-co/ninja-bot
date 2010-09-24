class QuotePlugin
  include NinjaPlugin

  match /quote (.+)/
  match /grab (.+)/, :method => :grab

  def usage
    "!quote <nick> [type]"
  end

  def grab(m, pattern)
    if chan = m.channel
      history = @bot.history[chan.name] || []

      puts history.inspect
      history.reverse_each do |message|
        next if message[:text] =~ /\!/

        if message[:text] =~ /#{Regexp.escape(pattern)}/ || message[:nick] =~ /#{Regexp.escape(pattern)}/
          user = Channel.get_user(chan.name, message[:nick])
          message = user.messages.create(:type => "famous", :text => message[:text], :created_at => message[:date])
          m.reply "#{m.user.nick}: grabbed! >> #{message.to_s}"
          break
        end
      end
    end
  end

  def execute(m, query)
    nick, type = query.split(" ", 2)

    if chan = m.channel
      user = Channel.get_user(chan.name, nick)

      conditions = {:user_id => user.id}
      if type
        conditions[:type] = type
      end

      if message = Message.random_message(conditions)
        m.reply "#{m.user.nick}: #{message.to_s}"
      end
    end
  end
end

register_plugin QuotePlugin