#
# Search on the php online documentation.
#
require "open-uri"

on :channel, /^!php (.+)/ do
  xhtml = Nokogiri::HTML( open( "http://www.php.net/results.php?q=#{match[0]}&p=manual&l=en" ) )
  xhtml.css( "#search-results li:first p.result a" ).each do | link |
    href = link[:href]
    if !href.match( /^http:\/\/(php.net|www.php.net)/i )
      href = "http://www.php.net" + href
    end

    msg channel, "#{nick}: " + link.content + " - #{href}"
  end
end