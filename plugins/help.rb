
class HelpPlugin
  include NinjaPlugin

  match /help/

  def usage
    "!help -- display the help"
  end

  def execute(m)
    self.bot.plugins.each do |plugin|
      if plugin.respond_to?(:usage)
        m.user.send "#{plugin.usage}"
      end
    end
  end
end

register_plugin HelpPlugin

