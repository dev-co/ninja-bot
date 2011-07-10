require 'open-uri'

class UsdToCopPlugin
  include NinjaPlugin

  match /usd2cop (\d+)/, method: :convert
  match /usd2cop$/, method: :trm

  def usage
    "!usd2cop [n] -- Convert US dollars to Colombian Pesos"
  end

  def convert(m, query)
    begin
      cop = open("http://usd2cop.heroku.com").read.to_i
      reply = cop * query.to_i
    rescue
      reply = "Error reading exchange rate :|"
    end
    m.reply "#{m.user.nick}: #{reply}"
  end

  def trm(m)
    convert(m, 1)
  end
end

register_plugin UsdToCopPlugin
