class JsdocPlugin
  include NinjaPlugin

  match /jsdoc (.+)/

  def usage
    "!jsdoc <class> [method] -- javascript documentation"
  end

  def execute(bot, query)
    count = 0

    klass, method = query.split(/\s|\.|\#/, 2)

    agent = Mechanize.new
    baseurl = "https://developer.mozilla.org/en/JavaScript/Reference"
    link = nil
    page = nil

    page = agent.get(baseurl)
    link = page.link_with(:text => /^\s*#{Regexp.escape(klass)}\s*$/i)

    result = "not found"
    found = false

    if link
      title = link.text

      url = link.uri.to_s
      if method
        page = link.click
        link = page.link_with(:text => /^#{Regexp.escape(method)}$/i)
        if link
          found = true
          desc = link.node.parent.next.next.content.strip
          result = "#{desc} #{link.uri.to_s}"
        end
      end

      if !found
        result = "#{title} #{url}"
      end
    end

    bot.reply "#{bot.user.nick}: #{result}"
  end
end

#register_plugin JsDocPlugin

