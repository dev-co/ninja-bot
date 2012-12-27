class QuotePlugin
  include NinjaPlugin

  match /quote (.+)/
  match /grab (.+)/, :method => :grab
  match /review\s?(.*)/, :method => :review

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

        if message.should_be_deleted?
          message.destroy
        end
      end
    end
  end

  def review(m, query)
    target_nick = query.to_s.strip.downcase
    current_user = User.where(:nick => m.user.nick.downcase).first
    msg = nil
    if target_nick.present? && (target = User.where(:nick => target_nick).first)
      msg = Message.random_message(:user_id => target.id, :_id.nin => current_user.reviewed)
      current_user.override(:current_message_id => msg.id, :reviewing => target.nick)
    elsif channel = Channel.find(m.channel.name.downcase)
      msg = Message.random_message(:channel_id => channel.id, :_id.nin => current_user.reviewed)
      current_user.override(:current_message_id => msg.id, :reviewing => channel.id)
    end
    m.user.send("#{msg.to_s} || type '+1' or '-1' to vote, 'next' to get a new message") if msg
  end
end

#register_plugin QuotePlugin
