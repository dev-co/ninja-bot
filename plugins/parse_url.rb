require "open-uri"

#
# Look if the message has a link and display his title.
#
on :channel, /(https?:\/\/([-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?)/ do
  xhtml = Nokogiri::HTML( open( "#{match[0].strip}" ) )
  xhtml.xpath( "//title" ).each do | title |
    if ( title.content )
      msg channel, title.content
    end
  end
end
