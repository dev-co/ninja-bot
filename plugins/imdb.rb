require 'imdb'

class ImdbPlugin
  include NinjaPlugin

  match /imdb (.+)/

  def usage
    "!imdb <query> -- search movies on imdb.com"
  end

  def execute(m, query)
    movies = Imdb::Search.new(query).movies
    movies[0,5].each_with_index do |movie, index|
      if index == 0
          m.reply "#{m.user.nick}: #{movie.title}[#{movie.year}] #{movie.plot.to_s[0,50]}.. #{movie.rating}/10 #{movie.url}"
      else
          m.user.send "#{movie.title}[#{movie.year}] #{movie.plot.to_s[0,50]}.. #{movie.rating}/10 #{movie.url}"
      end
    end
  end
end

register_plugin ImdbPlugin