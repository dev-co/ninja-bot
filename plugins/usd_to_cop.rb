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
      reply = currencify(cop * query.to_f)
    rescue
      reply = "Error reading exchange rate :|"
    end
    m.reply "#{m.user.nick}: #{reply}"
  end

  def trm(m)
    convert(m, 1)
  end

  # As seen in: http://codesnippets.joyent.com/posts/show/1812 
  # takes a number and options hash and outputs a string in any currency format
  def currencify(number, options={})
    # :currency_before => false puts the currency symbol after the number
    # default format: $12,345,678.90
    options = {:currency_symbol => "$", :delimiter => ",", :decimal_symbol => ".", :currency_before => true}.merge(options)
          
    # split integer and fractional parts 
    int, frac = ("%.2f" % number).split('.')
    # insert the delimiters
    int.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")
                     
    if options[:currency_before]
      options[:currency_symbol] + int + options[:decimal_symbol] + frac
    else
      int + options[:decimal_symbol] + frac + options[:currency_symbol]
    end

  end

end

register_plugin UsdToCopPlugin
