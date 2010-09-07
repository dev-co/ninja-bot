require 'json'
require 'open-uri'

class LastfmPlugin
  include NinjaPlugin

  match /lastfm (.+)/

  def usage
    "!lastfm <user> -- display top weekly artists"
  end

  def execute(bot, query)
    begin
      result = JSON.parse(open("http://ws.audioscrobbler.com/2.0/?method=user.getweeklyartistchart&user=#{URI.escape(query)}&api_key=b25b959554ed76058ac220b7b2e0a026&format=json").read)
      top_artists = result["weeklyartistchart"]["artist"][0..4]
      reply = "Top 5 Weekly Last.fm artists: "
      top_artists.each do |artist|
        reply = reply + "#{artist['name']} (#{artist['playcount']}), "
      end
      reply = reply[0..reply.length-3]
    rescue
      reply = "The user #{query} doesn't have a Last.fm account"
    end
    bot.reply "#{bot.user.nick}: #{reply}"
  end
end

class NowPlayingPlugin
  include NinjaPlugin

  match /np (.+)/, method: :np_user
  match /np/, method: :np

  def usage
    "!np [user] -- display last played song"
  end

  def np_user(bot, query)
    begin
      result = JSON.parse(open("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{URI.escape(query)}&api_key=b25b959554ed76058ac220b7b2e0a026&format=json").read)
      last_song = result["recenttracks"]["track"][0]
      reply = "#{last_song['name']} by #{last_song['artist']['#text']}"
    rescue
      reply = "The user #{query} doesn't have a Last.fm account"
    end
    bot.reply "#{bot.user.nick}: #{reply}"
  end
  
  def np(bot)
    begin
      result = JSON.parse(open("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{URI.escape(bot.user.nick)}&api_key=b25b959554ed76058ac220b7b2e0a026&format=json").read)
      last_song = result["recenttracks"]["track"][0]
      reply = "#{last_song['name']} by #{last_song['artist']['#text']}"
    rescue
      reply = "The user #{query} doesn't have a Last.fm account"
    end
    bot.reply "#{bot.user.nick}: #{reply}"    
  end
end

register_plugin LastfmPlugin
register_plugin NowPlayingPlugin