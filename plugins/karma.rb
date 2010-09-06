class KarmaPlugin
  include NinjaPlugin

  def usage
  end

  match /\b(\S+)\s*(\+\+|\-\-)(\s|$)/, :use_prefix => false

  def execute(m, nick, oper)
    return if m.channel.nil?

    puts "NICK: #{nick.inspect}"
    nick.sub!(":", "").downcase!
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

      if oper == "++" && source.can_increase_karma?
        target.karma_up!
        source.given_points_up!
        irc_user.send("Your karma has been increased by #{rnick}. currently you have [#{target.karma_up+1} - #{target.karma_down} == #{target.karma+1}] points of karma.")
        m.user.send("You have given 1 point of karma to #{irc_user.nick}. you have given #{source.given_points_today} points today")
      elsif oper == "--" && source.can_decrease_karma?
        target.karma_down!
        source.given_points_up!
        m.user.send("You have taken 1 point of karma from #{irc_user.nick}. you have given #{source.given_points_today} points today")
      end
    end
  end
end

register_plugin KarmaPlugin
