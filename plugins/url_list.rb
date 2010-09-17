class UrlListPlugin
  include NinjaPlugin

  match /urls (.+)/
  def usage
    "!urls <nick> [today|yesterday|date]"
  end

  def execute(m, query)
    localize!

    nick, date = query.downcase.split(/\s+/, 2)
    date ||= "today"
    puts "#{nick} -- #{date}"
    if chan = m.channel
      user = Channel.get_user(chan.name, nick)
      urls = user.urls_for(date)

      m.reply "#{m.user.nick}: #{urls.size} urls found..."

      urls.each do |url|
        m.user.send("#{url["link"]} -- #{url["title"]}")
      end
    end
  end
end

register_plugin UrlListPlugin
