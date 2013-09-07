class PhpdocPlugin
  include NinjaPlugin

  match /phpdoc (.+)/

  def usage
    "!phpdoc <function> -- php documentation"
  end

  def execute( bot, query )
    function_name = query.gsub( /[_-]+/, "-" )
    uri = "http://www.php.net/manual/en/function.#{function_name.strip}.php"

    begin
      doc = Nokogiri::HTML( open( uri ) )

      ver = doc.css( ".refnamediv p.verinfo" ).first
      if ver
        ver = ver.content.strip
      end

      desc = doc.css( ".refnamediv span.dc-title" ).first
      if desc
        desc = desc.content.strip
      end

      syn = doc.css( ".methodsynopsis" ).first
      if syn
        syn = syn.content.gsub( /[\s]{2,}/, " " ).strip
      end

      if ver != nil && desc != nil && syn != nil
        bot.reply "#{bot.user.nick}: #{ver} - #{desc} - #{shorten_url( uri )}"
        bot.reply "#{bot.user.nick}: #{syn}"
      else
        bot.reply "#{bot.user.nick}: not found"
      end
    rescue OpenURI::HTTPError => e
      bot.reply "#{bot.user.nick}: not found"
    rescue Exception => e
      puts e
    end
  end
end

#register_plugin PhpDocPlugin
