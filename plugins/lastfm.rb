require 'json'
require 'open-uri'

plugin "lastfm :text" do |m|
    text = m.args[:text]
    url = "http://ws.audioscrobbler.com/2.0/?method=user.getweeklyartistchart&user=#{URI.escape(text)}&api_key=b25b959554ed76058ac220b7b2e0a026&format=json"
    begin
      result = JSON.parse(open(url).read)
      top_artists = result["weeklyartistchart"]["artist"][0..4]
      
      reply = "Top 5 Weekly Last.fm artists: "
      top_artists.each do |artist|
        reply = reply + "#{artist['name']} (#{artist['playcount']}), "
      end
      
      reply = reply[0..reply.length-3]
      
    rescue
      reply = "The user #{text} doesn't have a Last.fm account"
    end
  
    m.reply "#{m.nick}: #{reply}"
end