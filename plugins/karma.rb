class KarmaPlugin
  include NinjaPlugin

  def usage
    "!karma <nick>"
  end

  match /karma (.+)/, :method => :stats
  match /fans (.+)/, :method => :fans
  match /\b(\S+)\s*(\+\+|\-\-|\+1|lol|thanks|thx|gracias)(\s|$)/, :use_prefix => false

  def stats(m, nick)
    if m.channel && (target = Channel.get_user(m.channel.name, nick, false))
      m.reply "#{m.user.nick}: #{nick} has +#{target.karma_up} -#{target.karma_down} =#{target.karma} points of karma"
    end
  end

  def fans(m, nick)
    if m.channel && (target = Channel.get_user(m.channel.name, nick, false))
      if target.fans.empty?
        m.reply "#{m.user.nick}: #{nick} doesn't have fans"
      else
        m.reply "#{m.user.nick}: #{target.fans.join(", ")} are fans of #{nick}"
      end
    end
  end

  def execute(m, nick, oper)
    return if m.channel.nil?

    synchronize(:karma) do
      nick.gsub!(/:|,/, "")
      nick.downcase!

      rnick = m.user.nick

      if rnick.downcase == nick
        return
      end

      irc_user = nil
      m.channel.users.each do |u, level|
        if u.nick.downcase == nick.downcase
          irc_user = u
          break
        end
      end

      if irc_user
        target = Channel.get_user(m.channel.name, irc_user.nick)
        source = Channel.get_user(m.channel.name, rnick)

        if (["++", "+1", "lol", "thx", "thanks", "gracias"].include?(oper)) && source.can_increase_karma?
          target.karma_up!
          target.add_fan(source.nick)
          source.given_points_up!
          irc_user.send("Your karma has been increased by #{rnick}. currently you have [#{target.karma_up+1} - #{target.karma_down} == #{target.karma+1}] points of karma.")
          #m.user.send("You have given 1 point of karma to #{irc_user.nick}. you have given #{source.given_points_today} points today")
        elsif oper == "--" && source.can_decrease_karma?
          target.karma_down!
          source.given_points_up!
          m.user.send("You have taken 1 point of karma from #{irc_user.nick}. you have given #{source.given_points_today} points today")
        end
      end
    end
  end
end

register_plugin KarmaPlugin
