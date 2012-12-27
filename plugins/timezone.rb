class TimezonePlugin
  include NinjaPlugin

  def usage
    "!time [zone]"
  end

  match /time\s*(.*)/

  def execute(m, zone)
    Time.zone = zone.strip
    if !Time.zone
      Time.zone = zone.strip.capitalize
    end
    localize! if !Time.zone

    if Time.zone
      m.reply "#{m.user.nick}: #{Time.zone.now}"
    else
      m.reply "#{m.user.nick}: #{Time.now}"
    end
  end
end

#register_plugin TimezonePlugin

