class QuotePlugin
  include NinjaPlugin

  match /quote (.+)/
  match /grab (.+)/, :method => :grab

  def usage
    "!quote <nick> [type]"
  end

  def grab(m, pattern)
    if chan = m.channel
      source = Channel.get_user(chan.name, m.user.nick)

      return if !source.can_grab_message?

      history = @bot.history[chan.name] || []

      history.reverse_each do |message|
        next if message[:text] =~ /^\!(\S+)/ || message[:nick].downcase == m.user.nick.downcase

        if message[:text] =~ /#{Regexp.escape(pattern)}/ || message[:nick] =~ /#{Regexp.escape(pattern)}/
          channel = Channel.find(m.channel.name.downcase)
          user = Channel.get_user(chan.name, message[:nick])
          
          message = user.messages.create(:type => "famous", 
                                         :text => message[:text], 
                                         :created_at => message[:date],
                                         :channel => channel,
                                         :created_by => source)
          m.reply "#{m.user.nick}: grabbed! >> #{message.to_s}"
          
          if source.can_increase_karma?
            user.karma_up!
            user.add_fan(source.nick)
            source.given_points_up!
          end
          
          break
        end
      end
    end
  end

  def execute(m, query)
    @bot.localize!

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
