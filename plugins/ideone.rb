require "ideone"
require "cgi"

class IdeonePugin
  include NinjaPlugin

  match /ideone (.+?) (.+)/

  def usage
    "!ideone <language> <code> -- ideone proxy"
  end

  def execute( bot, lang, code )
    begin
      lang = lang.chomp.downcase
      lang_id = Ideone::LANGUAGES[lang.to_sym] || Ideone::LANGUAGES[lang]

      if lang_id == nil
        bot.reply "#{bot.user.nick}: language not found"
        return
      end

      code = code.strip.chomp

      if !lang.match( /^<\?(?:php)?/i ) && lang_id == Ideone::LANGUAGES[:php]
        code = "<?php " + code
      end

      paste_id = Ideone.submit( lang_id, code )
      result = Ideone.run( paste_id, nil )
puts "*" * 20
p result
p result.strip
      bot.reply "#{bot.user.nick}: " + CGI.unescapeHTML( result.strip.gsub( /\n/, ", " ).gsub( /[\s]{2,}/, " " ) )
    rescue Ideone::IdeoneError => e
      bot.reply "#{bot.user.nick}: " + e
    rescue Exception => e
      puts e
    end
  end
end

register_plugin IdeonePugin
