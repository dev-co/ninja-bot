module XxxPlugin
  class Base
    def agent
      @agent ||= Mechanize.new
    end

    def random
      url, hrefp, enter = self.config
      enter ? agent.get(uri(url), &enter) : agent.get(uri(url))
      link = agent.page.links_with(:href => hrefp).choice
      title = link.text.to_s.strip
      href = link.href

      title = link.node.css("img").first["alt"] if title.empty?
      href = uri(href) if href !~ /^http/

      [title, href]
    end

    def config; raise NotImplementedError; end
    def host; raise NotImplementedError; end

    def uri(path); "#{self.host}#{path}"; end
  end

  class Youporn < Base
    def host
      "http://youporn.com"
    end

    def config
      ["/browse/time?page=#{rand(3100)+1}", /watch/, lambda { |page| page.forms.first.click_button }]
    end
  end

  class Xvideos < Base
    def host
      "http://xvideos.com"
    end

    def config
      ["/new/#{rand(7400)+1}", /video(\d+)/]
    end
  end

  class Pornhub < Base
    def host
      "http://pornhub.com"
    end

    def config
      ["/video?page=#{rand(1400)+1}", /view_video\.php/]
    end
  end
end

class XxxxPlugin
  include NinjaPlugin

  match /xxx/

  def usage
    "!xxx -- random xxx movie"
  end

  def execute(m)
    channels = [Xxx::Youporn, Xxx::Xvideos, Xxx::Pornhub]
    channel = channels.at(rand(channels.size)).new
    video = channel.random
    m.reply "#{m.user.nick}: #{video.first} -- #{video.last} #NSFW"
  end
end

#register_plugin XxxxPlugin
