
class FortunePlugin
  include NinjaPlugin

  match /fortune/

  def usage
    "!fortune -- display a random adage"
  end

  def execute(m)
    m.reply "#{m.user.nick}: #{`fortune`}".gsub(/[\n|\r|\t{2,}]/,' ')
  end
end

register_plugin FortunePlugin

