gem 'rae', '0.1.0'
require 'rae'

plugin "rae :text" do |m|
  safe_run(m, m.args) do |m, args|
    definitions = Rae.new.search(args[:text])
    definitions[0,5].each_with_index do |definition, index|
      if index == 0
	      m.reply "#{m.nick}: #{definition}"
      else
	      m.irc.privmsg m.nick, "#{definition}"
      end
    end
  end
end

