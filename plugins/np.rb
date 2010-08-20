require 'json'
require 'open-uri'

plugin "np :text" do |m|
    safe_run(m, m.args) do |m, args|
      text = args[:text]
      url = "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{URI.escape(text)}&api_key=b25b959554ed76058ac220b7b2e0a026&format=json"
      begin
        result = JSON.parse(open(url).read)
        last_song = result["recenttracks"]["track"][0]
        reply = "#{last_song['name']} by #{last_song['artist']['#text']}"
      rescue
        reply = "The user #{args[:text]} doesn't have a Last.fm account"
      end
      m.reply "#{m.nick}: #{reply}"
    end
end