require 'imdb'

plugin "imdb :text" do |m|
  Thread.start(m) do |m|
    movies = Imdb::Search.new(m.args[:text]).movies
    movies[0,3].each do |movie|
	    m.reply "#{m.nick}: #{movie.title}[#{movie.year}] #{movie.plot[0,50]}.. #{movie.rating}/10 #{movie.url}"
    end
  end
end

