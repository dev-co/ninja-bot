class TimezonePlugin
  include NinjaPlugin

  def usage
    "!time [zone]"
  end

  match /time\s*(.*)/

  def execute(m, zone)
    Time.zone = zone.strip.capitalize
    m.reply "#{m.user.nick}: #{Time.zone.now}"
  end
end

register_plugin TimezonePlugin

