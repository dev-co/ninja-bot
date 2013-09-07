gem 'rae', '1.5.0'
require 'rae'

class RaePlugin
  include NinjaPlugin

  match /rae (.+)/

  def usage
    "!rae <word> -- rae dictionary"
  end

  def execute(m, word)
    definitions = Rae.new.search(word)
    definitions[0,5].each_with_index do |definition, index|
      if index == 0
        m.reply "#{m.user.nick}: #{definition}"
      else
        m.user.send(definition)
      end
    end
  end
end

#register_plugin RaePlugin

