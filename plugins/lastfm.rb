require 'json'

class LastfmPlugin
  include NinjaPlugin

  match /lastfm (.+)/

  def usage
    "!lastfm <user> -- display top weekly artists"
  end

  def execute(m, query)
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
    m.reply "#{m.user.nick}: #{reply}"
  end
end

class NowPlayingPlugin
  include NinjaPlugin

  match /np (.+)/, method: :np_user
  match /np$/, method: :np
  match /np_alias (\S+)/, method: :np_alias

  def usage
    "!np [user] -- display last played song"
  end

  def np_user(m, query)
    begin
      result    = JSON.parse(open("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{URI.escape(query)}&api_key=b25b959554ed76058ac220b7b2e0a026&format=json&limit=1").read)
      last_song = result['recenttracks']['track']
      last_song = result['recenttracks']['track'].first if last_song.is_a? Array
      reply     = "♫ #{last_song['name']} - #{last_song['artist']['#text']} ♫"
    rescue
      reply = "The user #{query} doesn't have a Last.fm account"
    end
    m.reply "#{m.user.nick}: #{reply}"
  end

  def np(m)
    user = Channel.get_user(m.channel.name, m.user.nick)

    begin
      result    = JSON.parse(open("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{URI.escape(user.lastfm_user||user.nick)}&api_key=b25b959554ed76058ac220b7b2e0a026&format=json&limit=1").read)
      last_song = result['recenttracks']['track']
      last_song = result['recenttracks']['track'].first if last_song.is_a? Array
      reply     = "♫ #{last_song['name']} - #{last_song['artist']['#text']} ♫"
    rescue
      reply = "The user #{m.user.nick} doesn't have a Last.fm account"
    end
    m.reply "#{m.user.nick}: #{reply}"
  end

  def np_alias(m, query)
    user = Channel.get_user(m.channel.name, m.user.nick)
    user.override({:lastfm_user =>  query})
    m.reply "#{m.user.nick}: last.fm user updated to #{query.inspect}"
  end
end

register_plugin LastfmPlugin
register_plugin NowPlayingPlugin
