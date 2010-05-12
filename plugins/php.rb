require "open-uri"
require "cgi"

#
# Search on the online documentation
#
plugin "php :text" do |m|
  begin
    query = CGI.escape( m.args[:text].strip )
    xhtml = Nokogiri::HTML( open( "http://www.php.net/results.php?q=#{query}&p=manual&l=en" ) )
    xhtml.css( "#search-results li:first p.result a" ).each do | link |
      href = link[:href]
      if !href.match( /^http:\/\/(php.net|www.php.net)/i )
        href = "http://www.php.net" + href
      end

      m.reply "#{m.nick}: " + link.content.strip + " - #{href}"
    end
  rescue Exception => e
    p e
  end
end

#
# Display php function information
#
plugin "php_func :text" do |m|
  begin
    func = m.args[:text].gsub( /[_-]+/, "-" )
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
      m.reply "#{ver} - #{desc}"
      m.reply "#{syn}"
    else
      m.reply "Not Found"
    end
  rescue Exception => e
    p e
  end
end
