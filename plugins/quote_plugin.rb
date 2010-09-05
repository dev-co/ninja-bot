class QuotePlugin
  include NinjaPlugin

  match /quote (.+)/

  def usage
    "!quote <nick> [type]"
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
        m.reply "#{m.user.nick}: [#{message.created_at}] <#{user.nick}> #{message.text}"
      end
    end
  end
end

register_plugin QuotePlugin