require "open-uri"
require "cgi"

#
# Search on the online documentation
#
on :channel, /^!php (.+)/ do
  begin
    query = CGI.escape( match[0].strip )
    xhtml = Nokogiri::HTML( open( "http://www.php.net/results.php?q=#{query}&p=manual&l=en" ) )
    xhtml.css( "#search-results li:first p.result a" ).each do | link |
      href = link[:href]
      if !href.match( /^http:\/\/(php.net|www.php.net)/i )
        href = "http://www.php.net" + href
      end

      msg channel, "#{nick}: " + link.content.strip + " - #{href}"
    end
  rescue Exception => e
    p e
  end
end

#
# Display php function information
#
on :channel, /^!php_func (.+)/ do
  begin
    func = match[0].gsub( /[_-]+/, "-" )
    xhtml = Nokogiri::HTML( open( "http://www.php.net/manual/en/function.#{func.strip}.php" ) )

    ver = ""
    xhtml.css( ".refnamediv p.verinfo" ).each do | version |
      ver = version.content.strip
    end

    desc = ""
    xhtml.css( ".refnamediv span.dc-title" ).each do | description |
      desc = description.content.strip
    end

    syn = ""
    xhtml.css( ".methodsynopsis" ).each do | synopsis |
      syn = synopsis.content.gsub( /[\s]{2,}/, " " ).strip
    end

    if ver != "" && desc != "" && syn != ""
      msg channel, "#{ver} - #{desc}"
      msg channel, "#{syn}"
    else
      msg channel, "Not Found"
    end
  rescue Exception => e
    p e
  end
end
