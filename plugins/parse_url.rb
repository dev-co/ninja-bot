require "open-uri"

#
# Look if the message has a link and display his title.
#
# See: http://flanders.co.nz/2009/11/08/a-good-url-regular-expression-repost/
add_custom_pattern(:url, /((?:(?:ht|f)tp(?:s?)\:\/\/|~\/|\/)?(?:\w+:\w+@)?(?:(?:[-\w\d{1-3}]+\.)+(?:com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|edu|co\.uk|ac\.uk|it|fr|tv|museum|asia|local|travel|[a-z]{2})?)(?::[\d]{1,5})?(?:(?:(?:\/(?:[-\w~!$+|.,=]|%[a-f\d]{2})+)+|\/)+|\?|#)?(?:(?:\?(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)(?:&(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)*)*(?:#(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)?)/)
plugin ":text-url", {:prefix => ''} do |m|
  begin
    xhtml = Nokogiri::HTML( open( "#{m.args[:text].strip}" ) )
    if m.args[:text].scan(/https?:\/\/twitter.com\/(\w+)\/status(es)?\/(\d+)/).empty?
        xhtml.xpath( "//head/title" ).each do | title |
          if ( title.content )
            m.reply title.content.gsub( /([\n\t])+{1,}/, " " ).strip
          end
        end
    else
        xhtml.xpath( '//span[@class="entry-content"]' ).each do | tweet |
          if ( tweet.content )
            m.reply tweet.content.gsub( /([\n\t])+{1,}/, " " ).strip
          end
        end
    end 
  rescue Exception => e
    p e
  end
end
