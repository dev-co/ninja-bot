require "open-uri"

#
# Search on the online documentation
#
on :channel, /^!php (.+)/ do
  xhtml = Nokogiri::HTML( open( "http://www.php.net/results.php?q=#{match[0]}&p=manual&l=en" ) )
  xhtml.css( "#search-results li:first p.result a" ).each do | link |
    href = link[:href]
    if !href.match( /^http:\/\/(php.net|www.php.net)/i )
      href = "http://www.php.net" + href
    end

    msg channel, "#{nick}: " + link.content.strip + " - #{href}"
  end
end

#
# Display php function information
#
on :channel, /^!php_func (.+)/ do
  func = match[0].gsub( /[_-]+/, "-" )

  xhtml = Nokogiri::HTML( open( "http://www.php.net/manual/en/function.#{func}.php" ) )

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
end
