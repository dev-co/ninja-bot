class PydocPlugin
  include NinjaPlugin

  match /pydoc (.+)/

  def usage
    "!pydoc <class> [method] -- python documentation"
  end

  def execute(bot, query)
    count = 0

    klass, method = query.split(/\s|\.|\#/, 2)

    agent = Mechanize.new
    baseurl = "http://docs.python.org"
    link = nil
    page = nil

    page = agent.get("#{baseurl}/modindex.html")
    link = page.link_with(:text => /^\s*#{Regexp.escape(klass)}\s*$/i)

    result = "not found"
    found = false

    if link
      title = link.node.parent.parent.content.gsub(/\s+/, " ").strip

      url = "#{baseurl}/#{link.uri.to_s.split("%23", 2).first}"
      if method
        page = link.click
        ref = "##{klass}.#{method}"
        link = page.root.css("a[href='#{ref}'][class='headerlink']").first
        if link
          found = true
          desc = link.parent.parent.content.gsub(/\s+/, " ")
          result = "#{desc[0,250]}.. #{url}#{ref}"
        end
      end

      if !found
        result = "#{title} #{url}"
      end
    end

    bot.reply "#{bot.user.nick}: #{result}"
  end
end
#register_plugin PyDocPlugin
