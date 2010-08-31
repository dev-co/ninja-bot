require "ideone"

plugin "ideone :lang :code" do | c |
  begin
    lang = c.args[:lang].strip.chomp.downcase
    # yikes, isn't et all symbols? oh noes!
    lang_id = Ideone::LANGUAGES[lang.to_sym] || Ideone::LANGUAGES[lang]

    if lang_id == nil
      c.reply "#{c.nick}: language not found"
      raise ArgumentError, "language not found"
    end

    code = c.args[:code].strip.chomp

    if !lang.match( /^<\?(?:php)?/i ) && lang_id == Ideone::LANGUAGES[:php]
      code = "<?php " + code
    end

    # HACK: I don't know how to unescape this chars, cinch escape break lines
    # and all that stuff.
    paste_id = Ideone.submit( lang_id, code.gsub( /\\n/, "\n" ) )
    result = Ideone.run( paste_id, nil )
    c.reply "#{c.nick}: " + result
  rescue Ideone::IdeoneError => e
    c.reply "#{c.nick}: " + e.message
  rescue Exception => e
    p e
  end
end
