class AlarmPlugin
  include NinjaPlugin

  match /alarm (.+)\s*\>\s*(.+)/

  def initialize(*args)
    super(*args)

    @alarms ||= {}

    # TODO: load the alarms from database
  end

  def usage
    "!alarm <date> > <message> -- example: !alarm 22:00 > tea time"
  end

  def execute(m, date, message)
    localize!

    if @alarms[m.user.nick]
      @alarms[m.user.nick].wakeup rescue nil
    end

    date = Time.zone.parse(date)

    delay = date - Time.zone.now
    if delay < 0
      m.reply "#{m.user.nick}: invalid date"
      return
    end

    @alarms[m.user.nick] = Thread.current
    sleep delay

    m.reply "#{m.user.nick}: [#{date}] riiiing <#{message}>"
    @alarms[m.user.nick] = nil
  end
end

##register_plugin AlarmPlugin
