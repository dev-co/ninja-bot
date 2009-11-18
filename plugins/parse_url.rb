require "open-uri"

#
# Look if the message has a link and display his title.
#
# See: http://flanders.co.nz/2009/11/08/a-good-url-regular-expression-repost/
on :channel, /((?#Protocol)(http(?:s?)\:\/\/|~\/|\/)(?#Username:Password)(?:\w+:\w+@)?(?#Subdomains)(?:(?:[-\w]+\.)+(?#TopLevel Domains)(?:com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum|travel|[a-z]{2}))(?#Port)(?::[\d]{1,5})?(?#Directories)(?:(?:(?:\/(?:[-\w~!$+|.,:=]|%[a-f\d]{2})+)+|\/)+|\?|#)?(?#Query)(?:(?:\?(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)(?:&(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)*)*(?#Anchor)(?:#(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)?)/ do
p match[0].strip
  xhtml = Nokogiri::HTML( open( "#{match[0].strip}" ) )
  xhtml.xpath( "//title" ).each do | title |
    if ( title.content )
      msg channel, title.content
    end
  end
end
