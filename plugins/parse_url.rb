class ParseUrlPlugin
  include NinjaPlugin

  listen_to :channel, :method => :find_urls

  def usage
  end

  def recent_urls
    @recent_urls ||= {}
  end

  def find_urls(m)
    synchronize(:find_urls) do
    self.recent_urls[m.channel.name] ||= FixedQueue.new(10)

    # newtwitter's url fix
    message = m.message.to_s.gsub(/twitter.com\/#!\//, "twitter.com/")

    if message =~ /((?:(?:ht|f)tp(?:s?)\:\/\/|~\/|\/)?(?:\w+:\w+@)?(?:(?:[-\w\d{1-3}]+\.)+(?:com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|edu|co\.uk|ac\.uk|it|fr|tv|museum|asia|local|travel|[a-z]{2})?)(?::[\d]{1,5})?(?:(?:(?:\/(?:[-\w~!$+|.,=]|%[a-f\d]{2})+)+|\/)+|\?|#)?(?:(?:\?(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)(?:&(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)*)*(?:#(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)?)/
      url = $1.to_s.strip

      puts "received url #{url}"

      content = nil
      begin
        content = parse_url(url)
      rescue => e
        puts "error parsing url: #{e}"
        return
      end

      short_url = shorten_url(url)
      if recent_urls[m.channel.name].include?(short_url) || recent_urls[m.channel.name].include?(url)
        return
      end

      recent_urls[m.channel.name].add(short_url)
      recent_urls[m.channel.name].add(url)

      if content.present?
        m.reply "#{content} -- #{short_url}"
      elsif url =~ /\.pdf$/
        m.reply "View pdf online at #{shorten_url("http://docs.google.com/viewer?url="+url)}"
      end

      if (chan = m.channel) && m.user
        user = Channel.get_user(chan.name, m.user.nick)
        user.add_url(url, content)
      end
    end
    end
  end
end

#register_plugin ParseUrlPlugin
