require 'open-uri'
require 'nokogiri'

class UsdToCopPlugin
  include NinjaPlugin

  match /usd2cop ([-+]?[0-9]*\.?[0-9]+)/, method: :convert
  match /usd2cop$/, method: :trm

  def usage
    "!usd2cop [n] -- Convert US dollars to Colombian Pesos"
  end

  def convert(m, query)
    begin
      doc = Nokogiri::HTML(open("http://www.colombia.com/colombiainfo/estadisticas/dolar.asp"))
      cop = doc.css('.trm').last.children.to_s.gsub(',','').to_f
      reply = cop * query.to_f
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
