require "open-uri"

#
# Look if the message has a link and display his title.
#
# See: http://flanders.co.nz/2009/11/08/a-good-url-regular-expression-repost/
on :channel, /((?:(?:ht|f)tp(?:s?)\:\/\/|~\/|\/)?(?:\w+:\w+@)?(?:(?:[-\w\d{1-3}]+\.)+(?:com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|edu|co\.uk|ac\.uk|it|fr|tv|museum|asia|local|travel|[a-z]{2})?)(?::[\d]{1,5})?(?:(?:(?:\/(?:[-\w~!$+|.,=]|%[a-f\d]{2})+)+|\/)+|\?|#)?(?:(?:\?(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)(?:&(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)*)*(?:#(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)?)/ do
  begin
    xhtml = Nokogiri::HTML( open( "#{match[0].strip}" ) )
    xhtml.xpath( "//title" ).each do | title |
      if ( title.content )
        msg channel, title.content.gsub( /([\n\t])+{1,}/, " " ).strip
      end
    end
  rescue Exception => e
    p e
  end
end
