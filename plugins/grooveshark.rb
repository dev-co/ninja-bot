require "cgi"

class GroovesharkPlugin
  include NinjaPlugin

  match /gs (.+)/

  def usage
    "!gs <title> -- search music in Grooveshark"
  end

  def execute( bot, query )
    query = CGI.escape( query )
    # Retrieve songs (top 5) based on user query.
    songs = JSON.parse( open( "http://tinysong.com/s/#{ query }?format=json&limit=5" ).read )

    if songs.empty?
      bot.reply "#{bot.user.nick}: artist not found, sorry :("
      return
    end

    # Pop first array's first song for showing its information on channel.
    song = songs.slice! 0 if songs

    message = "#{ song[ 'SongName' ] } by #{ song[ 'ArtistName' ] } - #{ song[ 'Url' ] }"
    bot.reply "#{ bot.user.nick }: #{ message }".gsub(/[\n|\r|\t{2,}]/,' ')
    
    # Send through a private message the retrieved array of songs.
    songs.each do |s|
      bot.user.send "#{ s[ 'SongName' ] } by #{ s[ 'ArtistName' ] } - #{ s[ 'Url' ] }"
    end
  end
end

register_plugin GroovesharkPlugin
