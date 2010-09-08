require 'cgi'

class GooglePlugin
  include NinjaPlugin

  match /google (.+)/

  def search(query)
    url = "http://www.google.com/search?q=#{CGI.escape(query)}"
    res = Nokogiri::HTML(open(url)).at("h3.r")

    title = res.text
    link = res.at('a')[:href]
    desc = res.at("./following::div").children.first.text
    CGI.unescape_html "#{title} - #{desc} ( #{shorten_url(link)} ) -- all results at #{shorten_url(url)}"
  rescue => e
    puts e.message
    "No results found"
  end

  def execute(m, query)
    m.reply("#{m.user.nick}: #{search(query)}")
  end
end

register_plugin GooglePlugin

