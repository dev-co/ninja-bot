require 'imdb'

plugin "imdb :text" do |m|
  safe_run(m, m.args) do |m, args|
    movies = Imdb::Search.new(args[:text]).movies
    movies[0,5].each_with_index do |movie, index|
      if index == 0
	      m.reply "#{m.nick}: #{movie.title}[#{movie.year}] #{movie.plot.to_s[0,50]}.. #{movie.rating}/10 #{movie.url}"
      else
	      m.irc.privmsg m.nick, "#{movie.title}[#{movie.year}] #{movie.plot.to_s[0,50]}.. #{movie.rating}/10 #{movie.url}"
      end
    end
  end
end

