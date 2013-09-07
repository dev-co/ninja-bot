class SpellPlugin
  include NinjaPlugin

  match /spell (.+)/

  def usage
    '!spell <word> -- spell a word'
  end

  def execute(bot, word)
    word = word.upcase.split(//).join ' '
    bot.reply word
  end
end
#register_plugin SpellPlugin
