class MemoPlugin
  include NinjaPlugin

  match /(memo|note) (\S+) (.+)/, :method => :store
  listen_to :join, :method => :deliver

  def initialize(*args)
    super(*args)

    @memos ||= {}

    # TODO: load the alarms from database
  end

  def usage
    "!memo <nick> <msg> -- example: !memo david call me please"
  end

  def store(m, _, nick, txt)
    localize!

    has_user = false
    m.channel.users.each do |u, level|
      if u.nick.downcase == nick.downcase
        has_user = true
        break
      end
    end

    if !has_user
      @memos[nick] ||= []

      @memos[nick] << {"msg" => txt, "date" => Time.zone.now, "from" => m.user.nick}
      m.reply "#{m.user.nick}: memo saved."
    end
  end

  def deliver(m)
    nick = m.user.nick

    if @memos.include?(nick)
      while data = @memos[nick].shift
        m.reply "#{nick}: [#{data["date"]}] <#{data["from"]}> #{data["msg"]}"
      end
    end
  end
end

register_plugin MemoPlugin