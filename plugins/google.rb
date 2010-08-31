
class GooglePlugin
  include NinjaPlugin

  match /google (.+)/

  def usage
    "!google <query>"
  end

  def execute(m, query)
    m.reply shorten_url("http://lmgtfy.com/?q=#{query.gsub(/\s/, "+")}")
  end
end

register_plugin GooglePlugin
