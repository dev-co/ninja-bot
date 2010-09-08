
class LmgPlugin
  include NinjaPlugin

  match /lmg (.+)/

  def usage
    "!lmg <query>"
  end

  def execute(m, query)
    m.reply shorten_url("http://lmgtfy.com/?q=#{query.gsub(/\s/, "+")}")
  end
end

register_plugin LmgPlugin
