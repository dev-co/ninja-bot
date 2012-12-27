class CoderWallPlugin
  include NinjaPlugin

  match /coderwall (.+)/, :method => :coderwall
  match /coderwall$/, :method => :coderwall_nickless
  match /coderwall_alias (\S+)/, :method => :coderwall_alias

  def usage
    "!coderwall <username> -- search for user badges on coderwall.com service."
  end

  def coderwall( bot, username )
    execute( bot, username )
  end

  def coderwall_nickless( bot )
    user = Channel.get_user bot.channel.name, bot.user.nick
    user.update_attributes( :coderwall_user => user.nick ) unless user.coderwall_user
    execute( bot, user.coderwall_user )
  end

  def coderwall_alias( bot, coderwall_alias )
    user = Channel.get_user bot.channel.name, bot.user.nick
    user.update_attributes( :coderwall_user => coderwall_alias )
    bot.reply "#{ bot.user.nick }: coderwall user updated to #{ user.coderwall_user }."
  end

  def execute( bot, username )
    result = HTTParty.get "http://coderwall.com/#{ username }.json"
    message = "#{ bot.user.nick }: "
    if 'text/html' == result.content_type
      message += "user #{ username } not found."
    elsif 'application/json' == result.content_type
      result = JSON.parse result.body
      if 0 >= result[ 'badges' ].length
        message += "#{ username } has no badges."
      else
        badges = []
        result[ 'badges' ].each do |badge|
          badges << badge[ 'name' ]
        end
        message += "#{ username } has #{ badges.length } badges: #{ badges.join ', ' }"
      end
    else
      message += 'something went wrong.'
    end
    bot.reply message
  end
end

##register_plugin CoderWallPlugin
