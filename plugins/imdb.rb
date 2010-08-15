require 'imdb'

plugin "imdb :text" do |m|
  safe_run(m, m.args) do |m, args|
    movies = Imdb::Search.new(args[:text]).movies
    movies[0,3].each do |movie|
	    m.reply "#{m.nick}: #{movie.title}[#{movie.year}] #{movie.plot[0,50]}.. #{movie.rating}/10 #{movie.url}"
    end
  end
end

