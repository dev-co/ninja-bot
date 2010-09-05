class SeenPlugin
  include NinjaPlugin

  match /seen (.+)/

  def usage
    "!seen <nick>"
  end

  def execute(m, nick)
    return if m.channel.nil?

    rnick = m.user.nick

    if rnick.downcase == nick.downcase
      m.reply "#{rnick}: you need a new brain!"
      return
    end

    user = nil
    m.channel.users.each do |u, level|
      if u.nick.downcase == nick.downcase
        user = u
        break
      end
    end

    if user
      m.reply "#{rnick}: you need new glasses 8-)"
    elsif user = Channel.get_user(m.channel.name, nick, false)
      puts user.last_seen_at.class
      m.reply "#{rnick}: Last time I saw #{nick} was #{user.last_seen_at.ago_in_words}. it said: #{user.last_quit_message}"
    else
      m.reply "I've never seen that guy #{nick} over here."
    end
  end
end

register_plugin SeenPlugin